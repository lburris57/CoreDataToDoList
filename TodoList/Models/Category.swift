//
//  Category.swift
//  TodoList
//
//  Created by Larry Burris on 2/18/22.
//  Copyright © 2022 Larry Burris. All rights reserved.
//
import Foundation
import CoreData

//  Presentation layer struct that has computed fields that
//  return the values from the CategoryEntity database class
struct Category: Identifiable
{
    let categoryEntity: CategoryEntity
    
    var id: NSManagedObjectID
    {
        return categoryEntity.objectID
    }
    
    var categoryName: String
    {
        return categoryEntity.categoryName ?? Constants.EMPTY_STRING
    }
    
    var dateCreated: String
    {
        return categoryEntity.dateCreated?.asShortDateFormattedString() ?? Constants.EMPTY_STRING
    }
    
    var lastUpdated: String
    {
        return categoryEntity.lastUpdated?.asLongDateFormattedString() ?? Constants.EMPTY_STRING
    }
}
