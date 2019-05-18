//
// Created by artem on 5/2/19.
//

import Vapor
import FluentPostgreSQL

// Model
final class Category: Content {
    var id: Int?
    var name: String
    var company_fk: Company.ID

    init(name: String, company_fk: Company.ID) {
        self.name = name
        self.company_fk = company_fk
    }
}

// Extensions
extension Category {
    var company: Parent<Category, Company> {
        return parent(\.company_fk)
    }
}

extension Category {
    var product: Children<Category, Product> {
        return children(\.category_fk)
    }
}

extension Category: PostgreSQLModel {}
extension Category: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.company_fk, to: \Company.id)
            builder.unique(on: \.name)
        }
    }
}
extension Category: Parameter {}
