//
// Created by artem on 5/4/19.
//

import Vapor
import Fluent
import Authentication

struct ProductController: RouteCollection {
    
    func boot(router: Router) throws {

        let authSessionRoutes = router.grouped(Company.authSessionsMiddleware())

        authSessionRoutes.get("products", use: productsHandler)
        authSessionRoutes.get("products", "create", use: createProductHandler)
        authSessionRoutes.post(Product.self, at: "products", "create", use: createProductPostHandler)
        authSessionRoutes.post("products", Product.parameter, "delete", use: deleteProductPostHandler)
        authSessionRoutes.get("products", Product.parameter, "edit", use: editProductHandler)
        authSessionRoutes.post("products", Product.parameter, "edit", use: editProductPostHandler)

        let protectedRoutes = authSessionRoutes.grouped(RedirectMiddleware<Company>(path: "/login"))

        protectedRoutes.get("products", use: productsHandler)
        protectedRoutes.get("products", "create", use: createProductHandler)
        protectedRoutes.post(Product.self, at: "products", "create", use: createProductPostHandler)
        protectedRoutes.post("products", Product.parameter, "delete", use: deleteProductPostHandler)
        protectedRoutes.get("products", Product.parameter, "edit", use: editProductHandler)
        protectedRoutes.post("products", Product.parameter, "edit", use: editProductPostHandler)
    }

    // Product Context
    func productsHandler(_ req: Request) throws -> Future<View> {
        let company = try req.requireAuthenticated(Company.self)
        
        let categories = Category.query(on: req).filter(\Category.company_fk == company.id!).all()
        let products = Product.query(on: req).filter(\Product.company_fk == company.id!).all()
        
        return flatMap(to: View.self, categories, products) { categories, products in
            let context = ProductContext(categories: categories, products: products)
            return try req.view().render("products", context)
        }
    }

    func createProductHandler(_ req: Request) throws -> Future<View> {
        let company = try req.requireAuthenticated(Company.self)
        let categories = Category.query(on: req).filter(\Category.company_fk == company.id!).all()
        let context = CreateProductContext(categories: categories, company_fk: company.id!)
        return try req.view().render("createProduct", context)
    }
    
    func createProductPostHandler(_ req: Request, product: Product) throws -> Future<Response> {
        return product.save(on: req).flatMap(to: Response.self) { product in
            guard let _ = product.id else {
                throw Abort(.internalServerError)
            }
            return req.future(req.redirect(to: "/products"))
        } .catchMap() { error in
            return req.redirect(to: "/products")
        }
    }
    
    func editProductHandler(_ req: Request) throws -> Future<View> {
        let company = try req.requireAuthenticated(Company.self)
        let categories = Category.query(on: req).filter(\Category.company_fk == company.id!).all()
        return try req.parameters.next(Product.self).flatMap(to: View.self) { product in
            let context = EditProductContext(product: product, categories: categories)
            return try req.view().render("createProduct", context)
        }
    }
    
    func editProductPostHandler(_ req: Request) throws -> Future<Response> {
        return try flatMap(to: Response.self, req.parameters.next(Product.self), req.content.decode(Product.self)) { product, data in
            product.name = data.name
            product.barcode = data.barcode
            product.wholesalePrice = data.wholesalePrice
            product.markup = data.markup
            product.retailPrice = data.retailPrice
            
            product.category_fk = data.category_fk
            product.company_fk = data.company_fk
            
            return product.save(on: req).flatMap(to: Response.self) { product in
                guard let _ = product.id else {
                    throw Abort(.internalServerError)
                }
                
                return req.future(req.redirect(to: "/products"))
            } .catchMap { error in
                return req.redirect(to: "/products")
            }
        }
    }
    
    func deleteProductPostHandler(_ req: Request) throws -> Future<Response> {
        return try req.parameters.next(Product.self).delete(on: req).transform(to: req.redirect(to: "/products"))
    }
}
