//
//  StaffContext.swift
//  App
//
//  Created by Maxim Butin on 27/04/2019.
//

import Vapor

struct StaffContext: Content {
    let title = "Персонал"
    let positions: [Position]
    let staffs: [Staff]
}
