//
//  ListViewModel.swift
//  TodoList
//
//  Created by Larry Burris on 02/14/22.
//  Copyright © 2022 Larry Burris. All rights reserved.
//
import Foundation
import CloudKit
import CoreData

class ListViewModel: ObservableObject
{
    let viewContext = CoreDataManager.shared.persistentContainer.viewContext
    
    @Published var userName: String = "Anonymous"
    @Published var toDoItems: [ToDoItem] = []
    @Published var categories: [Category] = []
    
    let userNameKey: String = "userName"
    
    var isFiltered = false

    init()
    {
        retrieveToDoItems()
        retrieveUserNameFromUserDefaults()
    }
    
    // MARK: -
    // MARK: Filter Functions
    func filterToDoItems(searchType: String, sortOrder: String)
    {
        Log.info("SearchType is '\(searchType)' and sortOrder is '\(sortOrder)'")
        
        retrieveToDoItems()
        
        if searchType == "Completed"
        {
            isFiltered = true
            
            toDoItems = toDoItems.filter {$0.isCompleted == true}.sorted(by:
            {
                lhs, rhs in
                
                return sortOrder == "Ascending" ? lhs.lastUpdated < rhs.lastUpdated : lhs.lastUpdated > rhs.lastUpdated
            })
        }
        else if searchType == "Not Completed"
        {
            isFiltered = true
            
            toDoItems = toDoItems.filter {$0.isCompleted == false}.sorted(by:
            {
                lhs, rhs in
                
                return sortOrder == "Ascending" ? lhs.lastUpdated < rhs.lastUpdated : lhs.lastUpdated > rhs.lastUpdated
            })
        }
        else
        {
            isFiltered = false
            
            toDoItems = toDoItems.sorted(by:
            {
                lhs, rhs in
                
                return sortOrder == "Ascending" ? lhs.lastUpdated < rhs.lastUpdated : lhs.lastUpdated > rhs.lastUpdated
            })
        }
    }
    
    // MARK: -
    // MARK: Retrieve Functions
    func retrieveUserNameFromUserDefaults()
    {
        guard let data = UserDefaults.standard.data(forKey: userNameKey),
              let savedUserName = try? JSONDecoder().decode(String.self, from: data)
        else
        {
            saveUserNameToUserDefaults("Anonymous")
            
            return
        }

        //  Set the current user name to the user name in UserDefaults
        userName = savedUserName
        
        Log.info("Retrieved username from UserDefaults is: \(userName)")
    }

    func retrieveToDoItems()
    {
        toDoItems = ToDoItemEntity.all().map(ToDoItem.init)
    }
    
    func retrieveCategories()
    {
        categories = CategoryEntity.all().map(Category.init)
    }

    // MARK: -
    // MARK: Delete Functions
    func deleteItem(indexSet: IndexSet)
    {
        var toDoItem: ToDoItem
        
        toDoItem = toDoItems[indexSet.first!]
        
        if let retrievedToDoItem = ToDoItemEntity.byId(id: toDoItem.id) as? ToDoItemEntity
        {
            //  Delete the database record and refresh the list from the database
            retrievedToDoItem.delete()
        
            retrieveToDoItems()
        }
    }
    
    func deleteItem(toDoItem: ToDoItem)
    {
        if let retrievedToDoItem = ToDoItemEntity.byId(id: toDoItem.id) as? ToDoItemEntity
        {
            //  Delete the database record and refresh the list from the database
            retrievedToDoItem.delete()
        
            retrieveToDoItems()
        }
    }
    
    // MARK: -
    // MARK: Add Functions
    func addCategory(categoryName: String)
    {
        for category in categories
        {
            if category.categoryName == categoryName
            {
                return
            }
        }
        
        let categoryEntity = CategoryEntity(context: viewContext)
        
        categoryEntity.categoryName = categoryName.capitalized
        categoryEntity.createdBy = userName
        categoryEntity.dateCreated = Date()
        categoryEntity.lastUpdated = Date()
        
        categoryEntity.save()
        
        retrieveToDoItems()
        filterToDoItems(searchType: "No Filter", sortOrder: "Ascending")
    }

    func addToDoItem(title: String, description: String)
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
        filterToDoItems(searchType: "No Filter", sortOrder: "Ascending")
    }

    // MARK: -
    // MARK: Update Functions
    func updateIsCompleted(toDoItem: ToDoItem)
    {
        if let toDoItemEntity = ToDoItemEntity.byId(id: toDoItem.id) as? ToDoItemEntity
        {
            toDoItemEntity.isCompleted = !toDoItem.isCompleted
            toDoItemEntity.lastUpdated = Date()
            
            toDoItemEntity.save()
        }
        
        retrieveToDoItems()
    }
    
    func updateItem(toDoItem: ToDoItem)
    {
        if let toDoItemEntity = ToDoItemEntity.byId(id: toDoItem.id) as? ToDoItemEntity
        {
            toDoItemEntity.title = toDoItem.title
            toDoItemEntity.descriptionText = toDoItem.descriptionText
            toDoItemEntity.lastUpdated = Date()
            
            toDoItemEntity.save()
        }
        
        retrieveToDoItems()
        filterToDoItems(searchType: "No Filter", sortOrder: "Ascending")
    }
    
    // MARK: -
    // MARK: Save Functions
    func saveUserNameToUserDefaults(_ userName: String)
    {
        if let encodedData = try? JSONEncoder().encode(userName)
        {
            UserDefaults.standard.set(encodedData, forKey: userNameKey)
        }
        
        retrieveUserNameFromUserDefaults()
        filterToDoItems(searchType: "No Filter", sortOrder: "Ascending")
    }
}
