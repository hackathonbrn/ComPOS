import Vapor
import Fluent
import Authentication

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    // API
    let positionAPIController = PositionAPIController()
    try router.register(collection: positionAPIController)
    
    let categoryAPIController = CategoryAPIController()
    try router.register(collection: categoryAPIController)

    let staffAPIController = StaffAPIController()
    try router.register(collection: staffAPIController)

    let productAPIController = ProductAPIController()
    try router.register(collection: productAPIController)

    let salesTransactionAPIController = SalesTransactionAPIController()
    try router.register(collection: salesTransactionAPIController)

    let productInTransactionAPIController = ProductInTransactionAPIController()
    try router.register(collection: productInTransactionAPIController)
    
    
    // WEB
    let websiteController = WebsiteController()
    try router.register(collection: websiteController)

    let registrationController = RegistrationController()
    try router.register(collection: registrationController)

    let loginController = LoginController()
    try router.register(collection: loginController)

    let positionController = PositionController()
    try router.register(collection: positionController)

    let staffController = StaffController()
    try router.register(collection: staffController)

    let categoryController = CategoryController()
    try router.register(collection: categoryController)

    let productsController = ProductController()
    try router.register(collection: productsController)

    let settingsController = SettingsController()
    try router.register(collection: settingsController)

    let ckecksController = ChecksController()
    try router.register(collection: ckecksController)

    let logoutController = LogoutController()
    try router.register(collection: logoutController)
    
    let checksController = ChecksController()
    try router.register(collection: checksController)
}
