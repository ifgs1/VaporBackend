import Vapor
import VaporPostgreSQL

let drop = Droplet(
    preparations: [Acronym.self, User.self],
    providers: [VaporPostgreSQL.Provider.self]
)

/*drop.get("hello") { request in
    return "Hello, world!"
}*/

drop.get("version") { request in
    if let db = drop.database?.driver as? PostgreSQLDriver {
        let version = try db.raw("SELECT version()")
        return try JSON(node: version)
    }else {
        return "NO DB!"

    }
}

drop.get("model") { request in

    let acronym = Acronym(short: "BRB", long: "Be Right Back")
    return try acronym.makeJSON()
}

drop.get("test") { request in
    
    var acronym = Acronym(short: "BRB", long: "Be Right Back")
    try acronym.save()
    return try JSON(node:Acronym.all().makeNode())
}

let userController = UserRegistrationLoginController()
userController.addRoutes(to: drop)
drop.run()
