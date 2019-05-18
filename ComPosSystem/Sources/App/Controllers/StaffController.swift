//
// Created by artem on 5/4/19.
//

import Vapor
import Fluent
import Authentication

struct StaffController: RouteCollection {

    func boot(router: Router) throws {

        let authSessionRoutes = router.grouped(Company.authSessionsMiddleware())

        authSessionRoutes.get("staffs", use: staffsHandler)
        authSessionRoutes.get("staffs", "create", use: createStaffHandler)
        authSessionRoutes.post(Staff.self, at: "staffs", "create", use: createStaffPostHandler)
        authSessionRoutes.get("staffs", Staff.parameter, "edit", use: editStaffHandler)
        authSessionRoutes.post("staffs", Staff.parameter, "edit", use: editStaffPostHandler)
        authSessionRoutes.post("staffs", Staff.parameter, "delete", use: deleteStaffPostHandler)

        let protectedRoutes = authSessionRoutes.grouped(RedirectMiddleware<Company>(path: "/login"))

        protectedRoutes.get("staffs", use: staffsHandler)
        protectedRoutes.get("staffs", "create", use: createStaffHandler)
        protectedRoutes.post(Staff.self, at: "staffs", "create", use: createStaffPostHandler)
        protectedRoutes.get("staff", Staff.parameter, "edit", use: editStaffHandler)
        protectedRoutes.post("staffs", Staff.parameter, "edit", use: editStaffPostHandler)
        protectedRoutes.post("staffs", Staff.parameter, "delete", use: deleteStaffPostHandler)
    }

    // Staff Context
    func staffsHandler(_ req: Request) throws -> Future<View> {
        let company = try req.requireAuthenticated(Company.self)

        let  positions = Position.query(on: req).filter(\Position.company_fk == company.id!).all()
        let staffs = Staff.query(on: req).filter(\Staff.company_fk == company.id!).all()

        return flatMap(to: View.self, positions, staffs) { positions, staffs in
            let context = StaffContext(positions: positions, staffs: staffs)
            return try req.view().render("staffs", context)
        }
    }

    func createStaffHandler(_ req: Request) throws -> Future<View> {
        let company = try req.requireAuthenticated(Company.self)
        let positions = Position.query(on: req).filter(\Position.company_fk == company.id!).all()
        let context = CreateStaffContext(positions: positions, company_fk: company.id!)
        return try req.view().render("createStaff", context)
    }

    func createStaffPostHandler(_ req: Request, staff: Staff) throws -> Future<Response> {
        return staff.save(on: req).flatMap(to: Response.self) { staff in
            guard let _ = staff.id else {
                throw Abort(.internalServerError)
            }
            return req.future(req.redirect(to: "/staffs"))
        } .catchMap() { error in
                return req.redirect(to: "/staffs")
        }
    }

    func editStaffHandler(_ req: Request) throws -> Future<View> {
        let company = try req.requireAuthenticated(Company.self)
        let positions = Position.query(on: req).filter(\Position.company_fk == company.id!).all()
        return try req.parameters.next(Staff.self).flatMap(to: View.self) { staff in
            let context = EditStaffContext(staff: staff, positions: positions)
            return try req.view().render("createStaff", context)
        }
    }

    func editStaffPostHandler(_ req: Request) throws -> Future<Response> {
        return try flatMap(to: Response.self, req.parameters.next(Staff.self), req.content.decode(Staff.self)) { staff, data in
            
            staff.name = data.name
            staff.sirname = data.sirname
            staff.email = data.email
            staff.password = data.password
            
            staff.position_fk = data.position_fk
            staff.company_fk = data.company_fk
            
            return staff.save(on: req).flatMap(to: Response.self) { staff in
                guard let _ = staff.id else {
                    throw Abort(.internalServerError)
                }
                return req.future(req.redirect(to: "/staffs"))
                
                } .catchMap { error in
                    return req.redirect(to: "/staffs")
            }
        }
    }
    
    func deleteStaffPostHandler(_ req: Request) throws -> Future<Response> {
        return try req.parameters.next(Staff.self).delete(on: req).transform(to: req.redirect(to: "/staffs"))
    }
}
