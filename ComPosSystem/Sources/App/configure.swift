import Vapor
import Leaf
import FluentPostgreSQL
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {

    try services.register(FluentPostgreSQLProvider())
    
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    middlewares.use(FileMiddleware.self)
    middlewares.use(SessionsMiddleware.self)
    services.register(middlewares)
    
    // Configure a database
    var databases = DatabasesConfig()
    let databaseConfig = PostgreSQLDatabaseConfig(
        hostname: "localhost",
        username: "composuser",
        database: "composdb",
        password: nil)
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)

    var migrations = MigrationConfig()
    migrations.add(model: Company.self, database: .psql)
    migrations.add(model: Position.self, database: .psql)
    migrations.add(model: Staff.self, database: .psql)
    migrations.add(model: Category.self, database: .psql)
    migrations.add(model: Product.self, database: .psql)
    migrations.add(model: SalesTransaction.self, database: .psql)
    migrations.add(model: ProductInTransaction.self, database: .psql)
    services.register(migrations)
    
    try services.register(LeafProvider())
    try services.register(AuthenticationProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
}
