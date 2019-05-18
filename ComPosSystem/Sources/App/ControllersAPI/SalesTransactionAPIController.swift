//
// Created by artem on 5/10/19.
//

import Vapor
import Fluent
import Authentication

struct SalesTransactionAPIController: RouteCollection {
    func boot(router: Router) throws {
        // API
        let staffRoutes = router.grouped("api", "salesTransaction")
        staffRoutes.post(SalesTransaction.self, use: createHandler)
        staffRoutes.get("all", use: getAllHandler)
        staffRoutes.get("last7days", use: get7DaysHandler)
        staffRoutes.get("last30days", use: get30DaysHandler)
        //staffRoutes.get("last7daysCountChecks", use: get7DaysConuntCheks)
        
    }

    // CRUD (Create Read Update Delete) for SalesTransaction

    // POST
    func createHandler(_ req: Request, salesTransaction: SalesTransaction) throws -> Future<SalesTransaction> {
        return salesTransaction.save(on: req)
    }

    // GET
    // retieve all
    func getAllHandler(_ req: Request) throws -> Future<[SalesTransaction]> {
        return SalesTransaction.query(on: req).all()
    }

    // retieve last 7 days
    func get7DaysHandler(_ req: Request) throws -> Future<[SalesTransaction]> {
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date())
        return SalesTransaction.query(on: req).filter(\SalesTransaction.dataTime >= sevenDaysAgo!).all()
    }

    // retieve last 30 days
    func get30DaysHandler(_ req: Request) throws -> Future<[SalesTransaction]> {
        let calendar = Calendar.current
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: Date())
        return SalesTransaction.query(on: req).filter(\SalesTransaction.dataTime >= thirtyDaysAgo!).all()
    }


}
