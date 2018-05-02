//
//  UserPersistenceManager.swift
//  CoreData
//
//  Created by Ricardo Hochman on 01/05/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import CoreData

struct User {
    var name: String?
    
    static func fromPersistence(_ userPersistance: UserPersistence) -> User {
        return User(name: userPersistance.name)
    }
}

extension UserPersistence {
    func fromObject(_ user: User) {
        self.name = user.name
    }
}

class UserPersistenceManager: CoreDataManager {
    
    internal typealias T = UserPersistence
    
    static let sharedInstance = UserPersistenceManager()
    
    // CRUD: Create, Read, Update, Delete
    
    func createUser(_ user: User) {
        self.newEntity().fromObject(user)
        self.saveContext()
    }
    
    func users() -> [User]? {
        guard let usersPersistence = self.fetchData() else { return nil }
        return usersPersistence.map { User.fromPersistence($0) }
    }
    
    func user(name: String) -> User? {
        let predicate = NSPredicate(format: "name = %@", name)
        guard let result = self.fetchData(predicate)?.last else { return nil }
        return User.fromPersistence(result)
    }
    
    func updateUser(_ user: User) {
        // TODO: Improve the search method (using an ID)
        let predicate = NSPredicate(format: "name = %@", user.name ?? "")
        guard let result = self.fetchData(predicate)?.last else { return }
        result.fromObject(user)
        self.update(result)
    }
    
    func deleteUser(index: Int) {
        guard let allUsers = self.fetchData() else { return }
        self.delete(allUsers[index])
    }
    
}
