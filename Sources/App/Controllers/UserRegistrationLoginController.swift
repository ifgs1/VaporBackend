//
//  UserRegistrationLoginController.swift
//  BackendServices
//
//  Created by Ivan F Garcia S on 3/30/17.
//
//

import Vapor
import HTTP
import Auth
import Turnstile

final class UserRegistrationLoginController {
    func addRoutes(to drop: Droplet) {
        drop.post("login", handler: adminLogin)
        drop.post("register", handler: createAdmin)
    }
    
    func createAdmin(_ request: Request)throws -> ResponseRepresentable {
        guard let username = request.data["username"]?.string,
            let password = request.data["password"]?.string else {
                throw Abort.badRequest
        }
        
        
        let creds = UsernamePassword(username: username, password: password)
        var user = try User.register(credentials: creds) as? User
        if user != nil {
            try user!.save()
            return try user!.makeJSON()
        } else {
            return "User not found"
        }
    }
    
    func adminLogin(_ request: Request)throws -> ResponseRepresentable {
        guard let username = request.data["username"]?.string,
            let password = request.data["password"]?.string else {
                throw Abort.badRequest
        }
        
        let credentials = UsernamePassword(username: username, password: password)
        do {
            try request.auth.login(credentials, persist: true)
            return "Login success"
        } catch {
            return Response(redirect: "/login?succeded=false")
        }
    }
    
}
