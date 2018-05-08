//
//  UserPersistenceManager.swift
//  CoreData
//
//  Created by Ricardo Hochman on 01/05/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import CoreData

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
        return usersPersistence.map { User(fromPersistence: $0) }
    }
    
    func user(name: String) -> User? {
        let predicate = NSPredicate(format: "username = %@", name)
        guard let result = self.fetchData(predicate)?.last else { return nil }
        return User(fromPersistence: result)
    }
    
    private func user(id: UUID) -> UserPersistence? {
        let predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
        guard let result = self.fetchData(predicate)?.last else { return nil }
        return result
    }
    
    func updateUser(_ user: User) {
        guard let result = self.user(id: user.id!) else { return }
        result.fromObject(user)
        self.update(result)
    }
    
    func deleteUser(_ user: User) {
        guard let result = self.user(id: user.id!) else { return }
        self.delete(result)
    }
    
}
