import Vapor
import Fluent
import Authentication

struct CategoryController: RouteCollection {

    func boot(router: Router) throws {

        let authSessionRoutes = router.grouped(Company.authSessionsMiddleware())

        authSessionRoutes.get("categories", use: categoryHandler)
        authSessionRoutes.get("categories", "create", use: createCategoryHandler)
        authSessionRoutes.post(Category.self, at: "categories", "create", use: createCategoryPostHandler)
        authSessionRoutes.get("categories", Category.parameter, "edit", use: editCategoryHandler)
        authSessionRoutes.post("categories", Category.parameter, "edit", use: editCategoryPostHandler)
        authSessionRoutes.post("categories", Category.parameter, "delete", use: deleteCategoryPostHandler)

        let protectedRoutes = authSessionRoutes.grouped(RedirectMiddleware<Company>(path: "/login"))

        protectedRoutes.get("categories", use: categoryHandler)
        protectedRoutes.get("categories", "create", use: createCategoryHandler)
        protectedRoutes.post(Category.self, at: "categories", "create", use: createCategoryPostHandler)
        protectedRoutes.get("categories", Category.parameter, "edit", use: editCategoryHandler)
        protectedRoutes.post("categories", Category.parameter, "edit", use: editCategoryPostHandler)
        protectedRoutes.post("categories", Category.parameter, "delete", use: deleteCategoryPostHandler)
    }

    // Category Context
    func categoryHandler(_ req: Request) throws -> Future<View> {
        let company = try req.requireAuthenticated(Company.self)
        return Category.query(on: req).filter(\Category.company_fk == company.id!).all().flatMap(to: View.self) { categories in
            let context = CategoryContext(categories: categories, company_fk: company.id!)
            return try req.view().render("categories", context)
        }
    }

    func createCategoryHandler(_ req: Request) throws -> Future<View> {
        let company = try req.requireAuthenticated(Company.self)
        let context = CreateCategoryContext(company_fk: company.id!, isMessage: 0, message: "")
        return try req.view().render("createCategory", context)
    }

    func createCategoryPostHandler(_ req: Request, category: Category) throws -> Future<View> {
        let company = try req.requireAuthenticated(Company.self)
        let isCategory = Category.query(on: req).filter(\Category.name == category.name).filter(\Category.company_fk == company.id!).count()

        return isCategory.flatMap(to: View.self) { count in
            if (count == 0) {
                return category.save(on: req).flatMap(to: View.self) { category in
                    guard let _ = category.id else {
                        throw Abort(.internalServerError)
                    }
                    return Category.query(on: req).filter(\Category.company_fk == company.id!).all().flatMap(to: View.self) { categories in
                        let context = CreateCategoryContext(company_fk: company.id!, isMessage: 1, message: "Категория \"\(category.name)\" успешно добавлена")
                        return try req.view().render("createCategory", context)
                    }
                }
            }
            let context = CreateCategoryContext(company_fk: company.id!, isMessage: -1, message: "Категория \"\(category.name)\" уже существует")
            return try req.view().render("createCategory", context)
        }
    }

    func editCategoryHandler(_ req: Request) throws -> Future<View> {
        return try req.parameters.next(Category.self).flatMap(to: View.self) { category in
            let context = EditCategoryContext(category: category, isMessage: 0, message: "")
            return try req.view().render("createCategory", context)
        }
    }

    func editCategoryPostHandler(_ req: Request) throws -> Future<View> {
        let company = try req.requireAuthenticated(Company.self)

        return try flatMap(to: View.self, req.parameters.next(Category.self), req.content.decode(Category.self)) { category, data in
            let isCategory = Category.query(on: req).filter(\Category.name == data.name).filter(\Category.company_fk == company.id!).first()
            return isCategory.flatMap(to: View.self) { oneCategory in
                if (oneCategory != nil) {
                    if (oneCategory!.id! == category.id!) {
                        category.name = data.name
                        category.company_fk = data.company_fk
                        return category.save(on: req).flatMap(to: View.self) { category in
                            guard let _ = category.id else {
                                throw Abort(.internalServerError)
                            }
                            let context = EditCategoryContext(category: category, isMessage: 1, message: "Категория успешно добавлена")
                            return try req.view().render("createCategory", context)
                        }
                    }
                } else {
                    category.name = data.name
                    category.company_fk = data.company_fk
                    return category.save(on: req).flatMap(to: View.self) { category in
                        guard let _ = category.id else {
                            throw Abort(.internalServerError)
                        }
                        let context = EditCategoryContext(category: category, isMessage: 1, message: "Категория успешно отредактирована")
                        return try req.view().render("createCategory", context)
                    }
                }
                let context = EditCategoryContext(category: category, isMessage: -1, message: "Категория \"\(data.name)\" уже существует")
                return try req.view().render("createCategory", context)
            }
        }
    }

    func deleteCategoryPostHandler(_ req: Request) throws -> Future<Response> {
        return try flatMap(to: Response.self, req.parameters.next(Category.self), req.content.decode(Category.self)) { category, data in

            return category.delete(on: req).flatMap(to: Response.self) { category in
                return req.future(req.redirect(to: "/categories"))
            }.catchMap { error in
                return req.redirect(to: "/categories")
            }
        }
    }
}

