//
//  CreateCategoryContext.swift
//  App
//
//  Created by Maxim Butin on 05/05/2019.
//

import Vapor

struct CreateCategoryContext: Encodable {
    let title = "Создать категорию"
    let company_fk: Int
    let isMessage: Int
    let message: String
}
