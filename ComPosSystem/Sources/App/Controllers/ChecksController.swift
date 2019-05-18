//
//  ChecksController.swift
//  App
//
//  Created by Maxim Butin on 10/05/2019.
//

import Vapor
import Fluent
import Authentication

struct ChecksController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let authSessionRoutes = router.grouped(Company.authSessionsMiddleware())
        
        authSessionRoutes.get("checks", use: checksHandler)
        authSessionRoutes.get("checks", SalesTransaction.parameter, "detail", use: checksDetailHandler)

        let protectedRoutes = authSessionRoutes.grouped(RedirectMiddleware<Company>(path: "/login"))

        protectedRoutes.get("checks", use: checksHandler)
        protectedRoutes.get("checks", SalesTransaction.parameter, "detail", use: checksDetailHandler)
    }
    
    func checksHandler(_ req: Request) throws -> Future<View> {
        let company = try req.requireAuthenticated(Company.self)
        
        let staffs = Staff.query(on: req).filter(\Staff.company_fk == company.id!).all()
        let salesTransaction = SalesTransaction.query(on: req).filter(\SalesTransaction.company_fk == company.id!).all()
        
        return flatMap(to: View.self, staffs, salesTransaction) { staffs, salesTransaction in
            let context = CheckContext(staffs: staffs, checks: salesTransaction)
            return try req.view().render("checks", context)
        }
    }

    func checksDetailHandler(_ req: Request) throws -> Future<View> {
        let company = try req.requireAuthenticated(Company.self)
        let categories = Category.query(on: req).filter(\Category.company_fk == company.id!).all()
        let products = Product.query(on: req).filter(\Product.company_fk == company.id!).all()
        return try req.parameters.next(SalesTransaction.self).flatMap(to: View.self) { salesTransaction in
            let productsInTransaction = ProductInTransaction.query(on: req).filter(\ProductInTransaction.transaction_fk == salesTransaction.id!).all()
            let context = CheckDetailContext(productsInTransaction: productsInTransaction, products: products, categories: categories)
            return try req.view().render("productsInTransaction", context)
        }
    }
}
