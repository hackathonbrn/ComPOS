//
//  EditCategoryContext.swift
//  App
//
//  Created by Maxim Butin on 05/05/2019.
//

import Vapor

struct EditCategoryContext: Encodable {
    let title = "Редактировать категорию"
    let category: Category
    let editing = true
    let isMessage: Int
    let message: String
}
