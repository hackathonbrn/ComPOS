import Vapor
import Fluent
import Authentication

struct PositionController: RouteCollection {
    
    func boot(router: Router) throws {

        let authSessionRoutes = router.grouped(Company.authSessionsMiddleware())

        authSessionRoutes.get("positions", use: positionHandler)
        authSessionRoutes.get("positions", "create", use: createPositionHandler)
        authSessionRoutes.post(Position.self, at: "positions", "create", use: createPositionPostHandler)
        authSessionRoutes.get("positions", Position.parameter, "edit", use: editPositionHandler)
        authSessionRoutes.post("positions", Position.parameter, "edit", use: editPositionPostHandler)
        authSessionRoutes.post("positions", Position.parameter, "delete", use: deletePositionPostHandler)

        let protectedRoutes = authSessionRoutes.grouped(RedirectMiddleware<Company>(path: "/login"))

        protectedRoutes.get("positions", use: positionHandler)
        protectedRoutes.get("positions", "create", use: createPositionHandler)
        protectedRoutes.post(Position.self, at: "positions", "create", use: createPositionPostHandler)
        protectedRoutes.get("positions", Position.parameter, "edit", use: editPositionHandler)
        protectedRoutes.post("positions", Position.parameter, "edit", use: editPositionPostHandler)
        protectedRoutes.post("positions", Position.parameter, "delete", use: deletePositionPostHandler)
    }

    // Position Context
    func positionHandler(_ req: Request) throws -> Future<View> {
        let company = try req.requireAuthenticated(Company.self)
        return Position.query(on: req).filter(\Position.company_fk == company.id!).all().flatMap(to: View.self) { positions in
            let context = PositionContext(positions: positions, company_fk: company.id!)
            return try req.view().render("positions", context)
        }
    }

    func createPositionHandler(_ req: Request) throws -> Future<View> {
        let company = try req.requireAuthenticated(Company.self)
        let context = CreatePositionContext(company_fk: company.id!)
        return try req.view().render("createPosition", context)
    }

    func createPositionPostHandler(_ req: Request, position: Position) throws -> Future<Response> {
        return position.save(on: req).map(to: Response.self) { position in
            guard let _ = position.id else {
                throw Abort(.internalServerError)
            }
            return req.redirect(to: "/positions")
        }
    }

    func editPositionHandler(_ req: Request) throws -> Future<View> {
        return try req.parameters.next(Position.self).flatMap(to: View.self) { position in
            let context = EditPositionContext(position: position)
            return try req.view().render("createPosition", context)
        }
    }

    func editPositionPostHandler(_ req: Request) throws -> Future<Response> {
        
        return try flatMap(to: Response.self, req.parameters.next(Position.self), req.content.decode(Position.self)) { position, data in
            position.name = data.name
            position.company_fk = data.company_fk
            
            return position.save(on: req).flatMap(to: Response.self) { position in
                guard let _ = position.id else {
                    throw Abort(.internalServerError)
                    
                }
                return req.future(req.redirect(to: "/positions"))
                } .catchMap { error in
                    return req.redirect(to: "/positions")
            }
        }
    }

    func deletePositionPostHandler(_ req: Request) throws -> Future<Response> {
        return try flatMap(to: Response.self, req.parameters.next(Position.self), req.content.decode(Position.self)) { position, data in
            
            return position.delete(on: req).flatMap(to: Response.self) { position in
                return req.future(req.redirect(to: "/positions"))
                } .catchMap { error in
                    return req.redirect(to: "/positions")
            }
        }
    }
}
