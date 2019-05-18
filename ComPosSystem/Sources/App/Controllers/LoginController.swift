//
// Created by artem on 5/4/19.
//

import Vapor
import Fluent
import Crypto

struct LoginController: RouteCollection {

    struct LoginPostData: Content {
        let username: String
        let password: String
    }

    func boot(router: Router) throws {
        router.get("login", use: LoginHandler);
        router.post(LoginPostData.self, at: "login", use: LoginUserHandler);
    }

    func LoginHandler(_ req: Request) throws -> Future<View> {
        let context: AuthenticationContext
        if req.query[Bool.self, at: "error"] != nil {
            context = AuthenticationContext(loginError: true)
        } else {
            context = AuthenticationContext(loginError: false)
        }
        return try req.view().render("login", context)
    }

    func LoginUserHandler(_ req: Request, userData: LoginPostData) throws -> Future<Response> {
        return Company.authenticate(
                username: userData.username,
                password: userData.password,
                using: BCryptDigest(),
                on: req).map(to: Response.self) { company in
            guard let company = company else {
                return req.redirect(to: "login")
            }
            try req.authenticateSession(company)
            return req.redirect(to: "/")
        }
    }
}
