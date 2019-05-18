//
//  CreateProduct.swift
//  App
//
//  Created by Maxim Butin on 30/04/2019.
//

import Vapor

struct CreateProductContext: Encodable {
    let title = "Создать продукт"
    let categories: Future<[Category]>
    let company_fk: Int
}
