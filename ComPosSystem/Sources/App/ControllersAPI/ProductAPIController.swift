//
// Created by artem on 5/12/19.
//

import Vapor
import Fluent
import Authentication

struct ProductAPIController: RouteCollection {
    func boot(router: Router) throws {
        // API
        let staffRoutes = router.grouped("api", "product")
        staffRoutes.post(Product.self, use: createHandler)
        staffRoutes.get("all", use: getAllHandler)
    }

    // CRUD (Create Read Update Delete) for SalesTransaction

    // POST
    func createHandler(_ req: Request, product: Product) throws -> Future<Product> {
        return product.save(on: req)
    }

    // GET
    // retieve all
    func getAllHandler(_ req: Request) throws -> Future<[Product]> {
        return Product.query(on: req).all()
    }
}