//
//  StaffAPIController.swift
//  App
//
//  Created by Maxim Butin on 24/04/2019.
//

import Vapor
import Fluent
import Authentication

struct StaffAPIController: RouteCollection {
    func boot(router: Router) throws {
        // API
        let staffRoutes = router.grouped("api", "staffs")
        staffRoutes.post(Staff.self, use: createHandler)
        staffRoutes.get(use: getAllHandler)
        staffRoutes.get(Staff.parameter, use: getHandler)
        staffRoutes.put(Staff.parameter, use: updateHandler)
        staffRoutes.delete(Staff.parameter, use: deleteHandler)
        staffRoutes.get("search", use: searchHandler)
        staffRoutes.get("first", use: getFirtsHandler)
        
        // RENDER
        staffRoutes.get(Staff.parameter, "position", use: getPositionHandler)
    }
    
    // CRUD (Create Read Update Delete) for Staff
    
    // POST
    func createHandler(_ req: Request, staff: Staff) throws -> Future<Staff> {
        return staff.save(on: req)
    }
    
    // GET
    // retieve all staffs
    func getAllHandler(_ req: Request) throws -> Future<[Staff]> {
        return Staff.query(on: req).all()
    }
    
    // retieve single staff
    func getHandler(_ req: Request) throws -> Future<Staff> {
        return try req.parameters.next(Staff.self)
    }
    
    // retieve position handler
    func getPositionHandler(_ req: Request) throws -> Future<Position> {
        return try req.parameters.next(Staff.self).flatMap(to: Position.self) { staff in
            staff.position.get(on: req)
        }
    }
    
    // UPDATE
    func updateHandler(_ req: Request) throws -> Future<Staff> {
        return try flatMap(to: Staff.self, req.parameters.next(Staff.self), req.content.decode(Staff.self)) { staff, updateStaff in
            staff.name = updateStaff.name
            staff.sirname = updateStaff.sirname
            staff.email = updateStaff.email
            staff.password = updateStaff.password
            staff.position_fk = updateStaff.position_fk
            return staff.save(on: req)
        }
    }
    
    // DELETE
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Staff.self).delete(on: req).transform(to: .noContent)
    }
    
    // SEARCH
    func searchHandler(_ req: Request) throws -> Future<[Staff]> {
        guard let searchPosition = req.query[String.self, at: "email"] else {
            throw Abort(.badRequest)
        }
        return Staff.query(on: req).group(.or) { or in
            or.filter(\.name == searchPosition)
            or.filter(\.sirname == searchPosition)
        }.all()
    }
    
    // FIRST HANDLER
    func getFirtsHandler(_ req: Request) throws -> Future<Staff> {
        return Staff.query(on: req).first().unwrap(or: Abort(.notFound))
    }
}
