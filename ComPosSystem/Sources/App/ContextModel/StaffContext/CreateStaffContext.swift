//
//  CreateStaffContext.swift
//  App
//
//  Created by Maxim Butin on 27/04/2019.
//

import Vapor

struct CreateStaffContext: Encodable {
    let title = "Создать работника"
    let positions: Future<[Position]>
    let company_fk: Int
}
