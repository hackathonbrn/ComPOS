//
// Created by artem on 5/12/19.
//

import Vapor

struct CheckDetailContext: Encodable {
    let title = "Детали"
    let productsInTransaction: Future<[ProductInTransaction]>
    let products: Future<[Product]>
    let categories: Future<[Category]>
}
