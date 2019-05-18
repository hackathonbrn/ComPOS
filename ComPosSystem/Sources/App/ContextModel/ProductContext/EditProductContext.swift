//
//  EditProductContext.swift
//  App
//
//  Created by Maxim Butin on 09/05/2019.
//

import Vapor

struct EditProductContext: Encodable {
    let title = "Редактирование продукта"
    let product: Product
    let categories: Future<[Category]>
    let editing = true
}

