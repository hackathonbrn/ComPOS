//
//  ProductsContext.swift
//  App
//
//  Created by Maxim Butin on 30/04/2019.
//

import Vapor


struct ProductContext: Content {
    let title = "Продукты"
    let categories: [Category]
    let products: [Product]
}
