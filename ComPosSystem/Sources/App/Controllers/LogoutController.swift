//
// Created by artem on 5/4/19.
//

import Vapor
import Fluent
import Authentication

struct LogoutController: RouteCollection {

    func boot(router: Router) throws {

        let authSessionRoutes = router.grouped(Company.authSessionsMiddleware())
        authSessionRoutes.get("logout", use: logoutHandler);

        let protectedRoutes = authSessionRoutes.grouped(RedirectMiddleware<Company>(path: "/login"))
        protectedRoutes.get("logout", use: logoutHandler);
    }

    func logoutHandler(_ req: Request) throws -> Future<Response> {
        try req.unauthenticateSession(Company.self)
        return Future.map(on: req) { return req.redirect(to: "login") }
    }
}