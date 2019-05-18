//
//  ProductInTransaction.swift
//  App
//
//  Created by Maxim Butin on 10/05/2019.
//

import Vapor
import FluentPostgreSQL

final class ProductInTransaction: Content {
    var id: Int?
    var quantity: Int
    
    var product_fk: Product.ID
    var transaction_fk: SalesTransaction.ID
    var company_fk: Company.ID

    init(quantity: Int,
         product_fk: Product.ID,
         transaction_fk: SalesTransaction.ID,
         company_fk: Company.ID) {
        self.quantity = quantity
        self.product_fk = product_fk
        self.transaction_fk = transaction_fk
        self.company_fk = company_fk
    }
}

extension ProductInTransaction: PostgreSQLModel {}

extension ProductInTransaction {
    var product: Parent<ProductInTransaction, Product> {
        return parent(\.product_fk)
    }
}

extension ProductInTransaction {
    var salestransaction: Parent<ProductInTransaction, SalesTransaction> {
        return parent(\.transaction_fk)
    }
}

extension ProductInTransaction {
    var company: Parent<ProductInTransaction, Company> {
        return parent(\.company_fk)
    }
}

extension ProductInTransaction: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.product_fk, to: \Product.id)
            builder.reference(from: \.transaction_fk, to: \SalesTransaction.id)
            builder.reference(from: \.company_fk, to: \Company.id)
        }
    }
}
extension ProductInTransaction: Parameter {}
