//
//  Staff.swift
//  App
//
//  Created by Maxim Butin on 24/04/2019.
//

import Vapor
import FluentPostgreSQL

// Model
final class Staff: Content {
    var id: Int?
    var name: String
    var sirname: String
    var email: String
    var password: String

    var company_fk: Company.ID
    var position_fk: Position.ID
    
    init(name: String,
         sirname: String,
         email: String,
         password: String,
         position_fk: Position.ID,
         company_fk: Company.ID) {
        self.name = name
        self.sirname = sirname
        self.email = email
        self.password = password
        self.position_fk = position_fk
        self.company_fk = company_fk
    }
}

// Extensions
extension Staff: PostgreSQLModel {}

extension Staff {
    var position: Parent<Staff, Position> {
        return parent(\.position_fk)
    }
}

extension Staff {
    var company: Parent<Staff, Company> {
        return parent(\.company_fk)
    }
}

extension Staff {
    var product: Children<Staff, SalesTransaction> {
        return children(\.staff_fk)
    }
}

extension Staff: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
        try addProperties(to: builder)
            builder.reference(from: \.position_fk, to: \Position.id)
            builder.reference(from: \.company_fk, to: \Company.id)
            builder.unique(on: \.email)
        }
    }
}
extension Staff: Parameter {}
