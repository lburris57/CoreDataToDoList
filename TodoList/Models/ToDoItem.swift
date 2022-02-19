//
//  ToDoItem.swift
//  TodoList
//
//  Created by Larry Burris on 02/14/22.
//  Copyright © 2022 Larry Burris. All rights reserved.
//
import Foundation
import CoreData

//  Presentation layer struct that has computed fields that
//  return the values from the ToDoItemEntity database class
struct ToDoItem: Identifiable
{
    let toDoItemEntity: ToDoItemEntity
    
    var id: NSManagedObjectID
    {
        return toDoItemEntity.objectID
    }
    
    var category: String
    {
        return toDoItemEntity.category?.categoryName ?? Constants.EMPTY_STRING
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
        return toDoItemEntity.dateCreated?.asShortDateFormattedString() ?? Constants.EMPTY_STRING
    }
    
    var lastUpdated: String
    {
        return toDoItemEntity.lastUpdated?.asLongDateFormattedString() ?? Constants.EMPTY_STRING
    }
    
    var isCompleted: Bool
    {
        return toDoItemEntity.isCompleted
    }
}
