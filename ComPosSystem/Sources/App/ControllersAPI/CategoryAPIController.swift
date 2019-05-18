//
//  CategoryAPIController.swift
//  App
//
//  Created by Maxim Butin on 18/05/2019.
//

import Vapor
import Fluent
import Authentication

struct CategoryAPIController: RouteCollection {
    func boot(router: Router) throws {
        let categoryRoutes = router.grouped("api", "categories")
        categoryRoutes.get(use: getAllHandler)
        categoryRoutes.get(Category.parameter, use: getHandler)
        categoryRoutes.post(Category.self, use: createHandler)
        categoryRoutes.put(Category.parameter, use: updateHandler)
        categoryRoutes.delete(Category.parameter, use: deleteHandler)
        categoryRoutes.get("search", use: searchHandler)
        categoryRoutes.get(Category.parameter, "categories", use: getHandler)
    }
    
    // CRUD (Create Read Update Delete) for Position of Staff
    
    // POST
    func createHandler(_ req: Request, category: Category) throws -> Future<Category> {
        return category.save(on: req)
    }
    
    // GET
    // retieve all positions
    func getAllHandler(_ req: Request) throws -> Future<[Category]> {
        return Category.query(on: req).all()
    }
    
    // retieve single position
    func getHandler(_ req: Request) throws -> Future<Category> {
        return try req.parameters.next(Category.self)
    }
    
    
    /* Update
     1. Register a route for a PUT request to /api/positions/<ID> that returns
     Future<Position>.
     2. Use flatMap(to:_:_:), the dual future form of flatMap, to wait for both the parameter extraction and content decoding to complete.
     This provides both the position from the database and position from the request body to the closure.
     3. Update the position’s properties with the new values.
     4. Save the position and return the result.
     */
    func updateHandler(_ req: Request) throws -> Future<Category> {
        return try flatMap(to: Category.self, req.parameters.next(Category.self), req.content.decode(Category.self)) {
            category, updateCateogry in
            category.name = updateCateogry.name
            return category.save(on: req)
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
        return try req.parameters.next(Category.self).delete(on: req).transform(to: .noContent)
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
    func searchHandler(_ req: Request) throws -> Future<[Category]> {
        guard let searchName = req.query[String.self, at: "name"] else {
            throw Abort(.badRequest)
        }
        return Category.query(on: req).filter(\.name == searchName).all()
    }
}
