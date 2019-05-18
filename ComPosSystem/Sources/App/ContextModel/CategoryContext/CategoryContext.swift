//
// Created by artem on 5/5/19.
//

import Vapor

struct CategoryContext: Content {
    let title = "Категории"
    let categories: [Category]
    let company_fk: Int
}
