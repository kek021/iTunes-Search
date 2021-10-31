//
//  CoreDataInstance.swift
//  iTunesSearch
//
//  Created by Александр Жуков on 31.10.2021.
//

import Foundation
import CoreData

struct CoreDataInstance {
        
    let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "iTunesSearch")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    // MARK: - declare a variable with CoreData data
    
    var data: [Search] {
        
        let request = NSFetchRequest<Search>(entityName: "Search")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - if an element with the same name already exists, then first delete the old one, then create a new one
    
    func addNewRequest(with name: String, date: Date) {
        
        deleteRequest(with: name)
        let task = NSEntityDescription.insertNewObject(forEntityName: "Search", into: persistentContainer.viewContext)
        task.setValue(name, forKey: "searchRequest")
        task.setValue(date, forKey: "date")
        
        refreshData()
    }
    
    // MARK: - function to remove item from CoreData
    
    func deleteRequest(with name: String) {

        let fetchRequest: NSFetchRequest<Search> = Search.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["searchRequest", name])
        do {
            guard let task = try persistentContainer.viewContext.fetch(fetchRequest).first else {
                return
            }
            persistentContainer.viewContext.delete(task)
            refreshData()
        }
        catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }

    func refreshData() {
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
}

