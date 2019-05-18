//
//  Position.swift
//  App
//
//  Created by Maxim Butin on 23/04/2019.
//

import Vapor
import FluentPostgreSQL

// Model
final class Position: Content {
    var id: Int?
    var name: String
    var company_fk: Company.ID

    init(name: String, company_fk: Company.ID) {
        self.name = name
        self.company_fk = company_fk;
    }
}

// Extensions
extension Position {
    var company: Parent<Position, Company> {
        return parent(\.company_fk)
    }
}

// Extensions
extension Position {
    var staff: Children<Position, Staff> {
        return children(\.position_fk)
    }
}

extension Position: PostgreSQLModel {}
extension Position: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.company_fk, to: \Company.id)
            builder.unique(on: \.name)
        }
    }
}
extension Position: Parameter {}


