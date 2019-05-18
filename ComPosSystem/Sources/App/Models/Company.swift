//
// Created by artem on 5/2/19.
//

import Vapor
import FluentPostgreSQL
import Authentication

// Model
final class Company: Content {
    var id: Int?
    var email: String
    var password: String
    var namecompany: String
    var site: String?
    var tin: Int
    var address: String?
    var phone: String?

    init(email: String, password: String, namecompany: String, tin: Int) {
        self.email = email
        self.password = password
        self.namecompany = namecompany
        self.tin = tin
    }
}

extension Company {
    var position: Children<Company, Position> {
        return children(\.company_fk)
    }
}

extension Company {
    var category: Children<Company, Category> {
        return children(\.company_fk)
    }
}

extension Company {
    var product: Children<Company, Product> {
        return children(\.company_fk)
    }
}

extension Company {
    var staff: Children<Company, Staff> {
        return children(\.company_fk)
    }
}

extension Company {
    var productintransaction: Children<Company, ProductInTransaction> {
        return children(\.company_fk)
    }
}

extension Company: PostgreSQLModel {}
extension Company: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.tin)
            builder.unique(on: \.email)
        }
    }
}
extension Company: Parameter {}

extension Company: PasswordAuthenticatable {
    static var usernameKey: WritableKeyPath<Company, String> {
        return \Company.email
    }
    static var passwordKey: WritableKeyPath<Company, String> {
        return \Company.password
    }
}
extension Company: SessionAuthenticatable {}
