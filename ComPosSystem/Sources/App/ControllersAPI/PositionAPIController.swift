//
//  PositionAPIController.swift
//  App
//
//  Created by Maxim Butin on 24/04/2019.
//

import Vapor
import Fluent
import Authentication

struct PositionAPIController: RouteCollection {
    func boot(router: Router) throws {
        let positionRoutes = router.grouped("api", "positions")
        positionRoutes.get(use: getAllHandler)
        positionRoutes.get(Position.parameter, use: getHandler)
        positionRoutes.post(Position.self, use: createHandler)
        positionRoutes.put(Position.parameter, use: updateHandler)
        positionRoutes.delete(Position.parameter, use: deleteHandler)
        positionRoutes.get("search", use: searchHandler)
        positionRoutes.get("first", use: getFirstHandler)
        positionRoutes.get("sorted", use: sortedHandler)
        positionRoutes.get(Position.parameter, "staffs", use: getStaffHandler)
    }
    
    // CRUD (Create Read Update Delete) for Position of Staff
    
    // POST
    func createHandler(_ req: Request, position: Position) throws -> Future<Position> {
        return position.save(on: req)
    }
    
    // GET
    // retieve all positions
    func getAllHandler(_ req: Request) throws -> Future<[Position]> {
        return Position.query(on: req).all()
    }
    
    // retieve single position
    func getHandler(_ req: Request) throws -> Future<Position> {
        return try req.parameters.next(Position.self)
    }
    
    /* Update
     1. Register a route for a PUT request to /api/positions/<ID> that returns
     Future<Position>.
     2. Use flatMap(to:_:_:), the dual future form of flatMap, to wait for both the parameter extraction and content decoding to complete.
     This provides both the position from the database and position from the request body to the closure.
     3. Update the position’s properties with the new values.
     4. Save the position and return the result.
     */
    func updateHandler(_ req: Request) throws -> Future<Position> {
        return try flatMap(to: Position.self, req.parameters.next(Position.self), req.content.decode(Position.self)) {
            position, updatePosition in
            position.name = updatePosition.name
            return position.save(on: req)
        }
    }
    
    /*
     Delete
     1. Register a route for a DELETE request to /api/positions/<ID> that returns
     Future<HTTPStatus>.
     2. Extract the position to delete from the request’s parameters.
     3. Delete the position using delete(on:). Instead of requiring you to unwrap the returned Future,
     Fluent allows you to call delete(on:) directly on that Future. This helps tidy up code and reduce nesting.
     Fluent provides convenience functions for delete, update, create and save.
     4. Transform the result into a 204 No Content response. This tells the client the request has successfully completed but there’s no content to return.
     */
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Position.self).delete(on: req).transform(to: .noContent)
    }
    
    /*
     Search
     1. Register a new route handler for /api/acronyms/search that returns
     Future<[Acronym]>.
     2. Retrieve the search term from the URL query string. If this fails, throw a 400 Bad
     Request error.
     3. Use filter(_:) to find all acronyms whose short property matches the searchTerm.
     Because this uses key paths, the compiler can enforce type-safety on the properties and filter terms.
     This prevents run-time issues caused by specifying an invalid column name or invalid type to filter on.
    */
    func searchHandler(_ req: Request) throws -> Future<[Position]> {
        guard let searchName = req.query[String.self, at: "name"] else {
            throw Abort(.badRequest)
        }
        return Position.query(on: req).filter(\.name == searchName).all()
    }
    
    /*
     First result
     1. Register a new HTTP GET route for /api/acronyms/first that returns
     Future<Acronym>.
     2. Perform a query to get the first acronym.
     first() returns an optional as there may be no acronyms in the database.
     Use unwrap(or:) to ensure an acronym exists or throw a 404 Not Found error.
    */
    func getFirstHandler(_ req: Request) throws -> Future<Position> {
        return Position.query(on: req).first().unwrap(or: Abort(.notFound))
    }
    
    /*
     Sorting result
     Register a new HTTP GET route for /api/acronyms/sorted that returns
     Future<[Acronym]>.
     2. Create a query for Acronym and use sort(_:_:) to perform the sort.
     This function takes the key path of the field to sort on and the direction to sort in.
     Finally use all() to return all the results of the query.
    */
    func sortedHandler(_ req: Request) throws -> Future<[Position]> {
        return Position.query(on: req).sort(\.name, .ascending).all()
    }
    
    func getStaffHandler(_ req: Request) throws -> Future<[Staff]> {
        return try req.parameters.next(Position.self).flatMap(to: [Staff].self) { position in
            try position.staff.query(on: req).all()
        }
    }
}
