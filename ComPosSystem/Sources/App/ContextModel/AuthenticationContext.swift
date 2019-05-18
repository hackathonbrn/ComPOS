//
// Created by artem on 5/1/19.
//

import Vapor

struct AuthenticationContext: Encodable {
    let title = "Вход"
    let loginError: Bool
}
