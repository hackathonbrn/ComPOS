import Vapor
import Fluent
import Crypto

struct RegistrationController: RouteCollection {

    func boot(router: Router) throws {

        router.get("register", use: RegistrationHandler);
        router.post(Company.self, at: "register", use: RegistrationUserHandler)
    }

    func RegistrationHandler(_ req: Request) throws -> Future<View> {
        let context = RegistrationContext();
        return try req.view().render("register", context)
    }

    func RegistrationUserHandler(_ req: Request, company: Company) throws -> Future<Response> {
        try company.password = BCrypt.hash(company.password)
        return company.save(on: req).flatMap(to: Response.self) { company in
            guard let _ = company.id else {
                throw Abort(.internalServerError)
            }
            return req.future(req.redirect(to: "/login"))
            } .catchMap { error in
                return req.redirect(to: "/register")
            }
    }
}
