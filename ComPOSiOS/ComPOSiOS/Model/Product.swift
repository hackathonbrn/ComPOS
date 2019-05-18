//
//  Product.swift
//  ComPOSiOS
//
//  Created by Maxim Butin on 18/05/2019.
//  Copyright © 2019 Maxim Butin. All rights reserved.
//

import Foundation


struct Product: Codable {
    var id: Int
    var name: String
    var wholesalePrice: Double
    var markup: Int
    var retailPrice: Double
    var barcode: String
    var category_fk: Int
}

