//
//  SalesTransaction.swift
//  App
//
//  Created by Maxim Butin on 09/05/2019.
//

import Vapor
import FluentPostgreSQL

// Model
final class SalesTransaction: Content {
    var id: Int?
    var dataTime: Date?
    var wholesalePrice: Double
    var retailPrice: Double
    
    var company_fk: Company.ID
    var staff_fk: Staff.ID
    
    init(dataTime: Date?,
         wholesalePrice: Double,
         retailPrice: Double,
         staff_fk: Staff.ID,
         company_fk: Company.ID) {
        self.dataTime = dataTime
        self.wholesalePrice = wholesalePrice
        self.retailPrice = retailPrice
        self.staff_fk = staff_fk
        self.company_fk = company_fk
    }
}

// Extension
extension SalesTransaction: PostgreSQLModel {}

extension SalesTransaction {
    var staff: Parent<SalesTransaction, Staff> {
        return parent(\.staff_fk)
    }
}

extension SalesTransaction {
    var company: Parent<SalesTransaction, Company> {
        return parent(\.company_fk)
    }
}

extension SalesTransaction: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.company_fk, to: \Company.id)
            builder.reference(from: \.staff_fk, to: \Staff.id)
        }
    }
}
extension SalesTransaction: Parameter {}
