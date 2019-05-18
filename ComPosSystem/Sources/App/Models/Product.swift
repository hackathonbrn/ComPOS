//
//  Product.swift
//  App
//
//  Created by Maxim Butin on 30/04/2019.
//

import Vapor
import FluentPostgreSQL

// Model
final class Product: Content {
    var id: Int?
    var name: String
    var wholesalePrice: Double
    var markup: Int
    var retailPrice: Double
    var barcode: String
    
    var company_fk: Company.ID
    var category_fk: Category.ID

    init(name: String,
         wholesalePrice: Double,
         markup: Int,
         retailPrice: Double,
         barcode: String,
         category_fk: Category.ID,
         company_fk: Company.ID) {
        self.name = name
        self.wholesalePrice = wholesalePrice
        self.markup = markup
        self.retailPrice = retailPrice
        self.barcode = barcode
        self.category_fk = category_fk
        self.company_fk = company_fk
    }
}

// Extensions
extension Product {
    var category: Parent<Product, Category> {
        return parent(\.category_fk)
    }
}

extension Product {
    var company: Parent<Product, Company> {
        return parent(\.company_fk)
    }
}

extension Product: PostgreSQLModel {}
extension Product: Migration {
    public static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.category_fk, to: \Category.id)
            builder.reference(from: \.company_fk, to: \Company.id)
            builder.unique(on: \.name)
            builder.unique(on: \.barcode)
        }
    }
}
extension Product: Parameter {}
