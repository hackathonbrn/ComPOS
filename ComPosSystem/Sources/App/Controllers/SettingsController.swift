//
// Created by artem on 5/5/19.
//

import Vapor
import Fluent
import Authentication
import Crypto

struct SettingsController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let authSessionRoutes = router.grouped(Company.authSessionsMiddleware())

        authSessionRoutes.get("settings", use: settingsHandler)
        authSessionRoutes.post("settings", Company.parameter, use: editSettingsHandler)

        let protectedRoutes = authSessionRoutes.grouped(RedirectMiddleware<Company>(path: "/login"))

        protectedRoutes.get("settings", use: settingsHandler)
        protectedRoutes.post("settings", Company.parameter, use: editSettingsHandler)
    }
    
    func settingsHandler(_ req: Request) throws -> Future<View> {
        let company = try req.requireAuthenticated(Company.self)
        let context = CompanyContext(company: company)
        return try req.view().render("settings", context)
    }
    
    func editSettingsHandler(_ req: Request) throws -> Future<Response> {
        return try flatMap(to: Response.self, req.parameters.next(Company.self), req.content.decode(Company.self)) { company, data in
            company.email = data.email
            company.password = data.password
            company.namecompany = data.namecompany
            company.site = data.site
            company.tin = data.tin
            company.address = data.address
            company.phone = data.phone
            
            guard let _ = company.id else {
                throw Abort(.internalServerError)
            }
            
            let redirect = req.redirect(to: "/")
            return company.save(on: req).transform(to: redirect)
        }
    }
}
