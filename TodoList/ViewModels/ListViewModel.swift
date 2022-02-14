//
//  ListViewModel.swift
//  TodoList
//
//  Created by Nick Sarno on 3/3/21
//  Adapted by Larry Burris on 2/14/2022
//
import Foundation
import CloudKit
import UIKit
import CoreData

class ListViewModel: ObservableObject
{
    let viewContext = CoreDataManager.shared.persistentContainer.viewContext
    
    @Published var userName: String = "Anonymous"
    
    @Published var toDoItems: [ToDoItem] = []
    
    let itemsKey: String = "items_list"
    let userNameKey: String = "userName"

    init()
    {
        retrieveToDoItems()
        retrieveUserNameFromUserDefaults()
    }
    
    func retrieveUserNameFromUserDefaults()
    {
        guard let data = UserDefaults.standard.data(forKey: userNameKey),
              let savedUserName = try? JSONDecoder().decode(String.self, from: data)
        else
        {
            saveUserNameInformation("Anonymous")
            return
        }

        userName = savedUserName
        
        Log.info("Saved username is: \(userName)")
    }

    func retrieveToDoItems()
    {
        toDoItems = ToDoItemEntity.all().map(ToDoItem.init)
    }

    func deleteItem(indexSet: IndexSet)
    {
        var toDoItem: ToDoItem
        
        toDoItem = toDoItems[indexSet.first!]
        
        if let retrievedToDoItem = ToDoItemEntity.byId(id: toDoItem.id) as? ToDoItemEntity
        {
            //  Delete the satabase record
            retrievedToDoItem.delete()
        
            retrieveToDoItems()
        }
    }

    func moveItem(from: IndexSet, to: Int)
    {
        toDoItems.move(fromOffsets: from, toOffset: to)
    }

    func addItem(title: String, description: String)
    {
        let toDoItemEntity = ToDoItemEntity(context: viewContext)
        
        toDoItemEntity.title = title.capitalized
        toDoItemEntity.descriptionText = description
        toDoItemEntity.createdBy = userName
        toDoItemEntity.isCompleted = false
        toDoItemEntity.dateCreated = Date()
        toDoItemEntity.lastUpdated = Date()
        
        toDoItemEntity.save()
        
        retrieveToDoItems()
    }

    func updateItem(toDoItem: ToDoItem)
    {
        if let toDoItemEntity = ToDoItemEntity.byId(id: toDoItem.id) as? ToDoItemEntity
        {
            toDoItemEntity.isCompleted = !toDoItem.isCompleted
            toDoItemEntity.lastUpdated = Date()
        }
        
        retrieveToDoItems()
    }
    
    func saveUserNameInformation(_ userName: String)
    {
        if let encodedData = try? JSONEncoder().encode(userName)
        {
            UserDefaults.standard.set(encodedData, forKey: userNameKey)
        }
        
        retrieveUserNameFromUserDefaults()
    }
}
