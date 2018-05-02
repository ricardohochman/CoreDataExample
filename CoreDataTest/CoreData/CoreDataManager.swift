//
//  CoreDataManager.swift
//  CoreData
//
//  Created by Ricardo Hochman on 01/05/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import CoreData
import UIKit

protocol CoreDataManager {
    associatedtype T: NSManagedObject
}

extension CoreDataManager {

    func newEntity() -> T {
        let context = AppDelegate().sharedInstance().persistentContainer.viewContext
        return NSEntityDescription.insertNewObject(forEntityName: T.entityName(), into: context) as! T
    }

    func fetchData(_ predicate: NSPredicate? = NSPredicate(format: "TRUEPREDICATE")) -> [T]? {
        
        let fetch = NSFetchRequest<T>(entityName: T.description())
        fetch.predicate = predicate
        
        do {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let resultSet : [Any] = try appDelegate.persistentContainer.viewContext.fetch(fetch)
                return resultSet as? [T] ?? []
            }
            
        } catch {
            print(#function, error)
        }
        
        return nil
    }
    
    func update(_ object: T) {
        self.saveContext()
    }
    
    func delete(_ object: T) {
        let context = AppDelegate().sharedInstance().persistentContainer.viewContext
        context.delete(object)
        self.saveContext()
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = AppDelegate().sharedInstance().persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension NSManagedObject {
    class func entityName() -> String {
        return self.entity().name ?? ""
    }
}

