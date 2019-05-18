//
//  CreatePositionContext.swift
//  App
//
//  Created by Maxim Butin on 27/04/2019.
//

import Vapor

struct CreatePositionContext: Encodable {
    let title = "Создать должность"
    let company_fk: Int
}
