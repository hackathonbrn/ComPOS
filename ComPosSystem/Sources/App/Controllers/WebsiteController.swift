//
//  WebsiteController.swift
//  App
//
//  Created by Maxim Butin on 24/04/2019.
//

import Vapor
import Leaf
import Fluent
import Authentication

struct WebsiteController: RouteCollection {

    func boot(router: Router) throws {

        let authSessionRoutes = router.grouped(Company.authSessionsMiddleware())
        authSessionRoutes.get(use: indexHandler)

        let protectedRoutes = authSessionRoutes.grouped(RedirectMiddleware<Company>(path: "/login"))
        protectedRoutes.get(use: indexHandler)

    }

    // TODO: впилить графики
    // Index Context
    func indexHandler(_ req: Request) throws -> Future<View> {
        let positions = Position.query(on: req).all()
        let staffs = Staff.query(on: req).all()
        return flatMap(to: View.self, positions, staffs) { positions, cakes in
            let context = IndexContext(positions: positions, staffs: staffs)
            return try req.view().render("index", context)
        }
    }
}
