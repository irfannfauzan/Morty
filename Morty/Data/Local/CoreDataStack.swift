//
//  CoreDataStack.swift
//  Morty
//
//  Created by Vokal-Ican on 22/11/26.
//

import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        container = NSPersistentContainer(name: "Morty")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load Core Data: \(error)")
            }
        }
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Failed to save Core Data:", error)
        }
    }
}
