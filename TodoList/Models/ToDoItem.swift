//
//  ToDoItem.swift
//  TodoList
//
//  Created by Nick Sarno on 3/2/21
//  Adapted for Core Data by Larry Burris on 2/14/2022
//
import Foundation
import CoreData

struct ToDoItem: Identifiable
{
    let toDoItemEntity: ToDoItemEntity
    
    var id: NSManagedObjectID
    {
        return toDoItemEntity.objectID
    }
    
    var title: String
    {
        return toDoItemEntity.title ?? Constants.EMPTY_STRING
    }
    
    var descriptionText: String
    {
        return toDoItemEntity.descriptionText ?? Constants.EMPTY_STRING
    }
    
    var createdBy: String
    {
        return toDoItemEntity.createdBy ?? Constants.EMPTY_STRING
    }
    
    var dateCreated: String
    {
        return toDoItemEntity.dateCreated?.asFormattedString() ?? Constants.EMPTY_STRING
    }
    
    var lastUpdated: String
    {
        return toDoItemEntity.lastUpdated?.getTextFromDate() ?? Constants.EMPTY_STRING
    }
    
    var isCompleted: Bool
    {
        return toDoItemEntity.isCompleted
    }
}

extension Date
{
    func getTextFromDate() -> String
    {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, MMM d, yyyy hh:mm a"
        return formatter.string(from: self)
    }
    
    func asFormattedString() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self)
    }
}
