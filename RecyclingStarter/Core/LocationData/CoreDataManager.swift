//
//  CoreDataManager.swift
//  RecyclingStarter
//
//  Created by  Matvey on 31.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit
import CoreData


enum localStorageResault {
    case success
    case error
}


class CoreDataManager {
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecyclingStarter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    private var context : NSManagedObjectContext {
        let context = persistentContainer.viewContext
        return context
    }
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveData(email: String, password: String, callback: @escaping(_ resault: localStorageResault)->Void) {
        persistentContainer.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<UserInfo>(entityName: "UserInfo")
            do{
                let allUserInfo = try context.fetch(fetchRequest)
                for oldUser in allUserInfo{
                    context.delete(oldUser)
                }
            } catch {}
            
            let user = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: context) as? UserInfo
            user?.email = email
            user?.password = password
            
            do{
                try context.save()
                callback(localStorageResault.success)
            } catch{
                callback(localStorageResault.error)
            }
        }
    }
    
    func loadData(callback: @escaping(_ resault: localStorageResault, _ userInfo: UserInfo?)->Void) {
        persistentContainer.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<UserInfo>(entityName: "UserInfo")
            do{
                let allUsers = try context.fetch(fetchRequest)
                guard allUsers.count > 0 else{
                    callback(localStorageResault.error, nil)
                    return
                }
                callback(localStorageResault.success, allUsers[0])
            } catch {
                callback(localStorageResault.error, nil)
            }
        }
    }
}
