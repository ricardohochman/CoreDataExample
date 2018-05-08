//
//  User.swift
//  CoreDataTest
//
//  Created by Ricardo Hochman on 07/05/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import Foundation

struct User: Decodable {
    var id: UUID?
    var username: String?
    
    init(username: String?) {
        self.id = UUID()
        self.username = username
    }
    
    init(id: UUID?, username: String?) {
        self.id = id
        self.username = username
    }
    
    init(fromPersistence user: UserPersistence) {
        self.init(id: user.id,
                  username: user.username)
    }
    
}

extension UserPersistence {
    func fromObject(_ user: User) {
        self.id = user.id
        self.username = user.username
    }
}
