//
// Created by artem on 5/5/19.
//

import Vapor

struct CompanyContext: Encodable {
    let title = "Настройки компании"
    let company: Company
}
