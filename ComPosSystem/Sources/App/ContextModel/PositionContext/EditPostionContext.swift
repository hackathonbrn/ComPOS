//
//  EditPostionContext.swift
//  App
//
//  Created by Maxim Butin on 27/04/2019.
//

import Vapor

struct EditPositionContext: Encodable {
    let title = "Редактировать должность"
    let position: Position
    let editing = true
}
