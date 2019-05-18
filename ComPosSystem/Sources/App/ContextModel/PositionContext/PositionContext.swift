//
//  PositionContext.swift
//  App
//
//  Created by Maxim Butin on 27/04/2019.
//

import Vapor

struct PositionContext: Content {
    let title = "Должности"
    let positions: [Position]
    let company_fk: Int
}
