//
// Created by artem on 5/11/19.
//

import Vapor
import Fluent
import Authentication

struct ProductInTransactionAPIController: RouteCollection {
    func boot(router: Router) throws {
        // API
        let staffRoutes = router.grouped("api", "productInTransaction")
        staffRoutes.post(ProductInTransaction.self, use: createHandler)
        staffRoutes.get("all", use: getAllHandler)
    }

    // CRUD (Create Read Update Delete) for SalesTransaction

    // POST
    func createHandler(_ req: Request, productInTransaction: ProductInTransaction) throws -> Future<ProductInTransaction> {
        return productInTransaction.save(on: req)
    }

    // GET
    // retieve all
    func getAllHandler(_ req: Request) throws -> Future<[ProductInTransaction]> {
        return ProductInTransaction.query(on: req).all()
    }
}
