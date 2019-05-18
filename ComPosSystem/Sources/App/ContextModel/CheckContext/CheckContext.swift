//
//  CheckContext.swift
//  App
//
//  Created by Maxim Butin on 10/05/2019.
//

import Vapor

struct CheckContext: Content {
    let title = "Чеки"
    let staffs: [Staff]
    let checks: [SalesTransaction]
}
