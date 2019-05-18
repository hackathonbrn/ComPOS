//ApplicationResponder
//  IndexContext.swift
//  App
//
//  Created by Maxim Butin on 27/04/2019.
//

import Vapor

struct IndexContext: Encodable {
    let title = "Статистика"
    let positions: [Position]
    let staffs: Future<[Staff]>
}
