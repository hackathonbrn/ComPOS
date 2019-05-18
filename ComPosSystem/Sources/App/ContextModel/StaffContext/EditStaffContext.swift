//
//  EditStaffContext.swift
//  App
//
//  Created by Maxim Butin on 27/04/2019.
//

import Vapor

struct EditStaffContext: Encodable {
    let title = "Редактировать работника"
    let staff: Staff
    let positions: Future<[Position]>
    let editing = true
}
