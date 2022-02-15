//
//  CoreDataManager.swift
//  TodoList
//
//  Created by Larry Burris on 02/14/22.
//  Copyright © 2022 Larry Burris. All rights reserved.
//
import CoreData
import Foundation

class CoreDataManager
{
    let persistentContainer: NSPersistentContainer

    static let shared: CoreDataManager = CoreDataManager()

    private init()
    {
        persistentContainer = NSPersistentContainer(name: "ToDoDatabaseModel")

        persistentContainer.loadPersistentStores
        {
            _, error in

            if let error = error
            {
                Log.error("Unable to initialize Core Data: \(error.localizedDescription)")
            }
            else
            {
                Log.info("ToDoDatabaseModel was successfully loaded!!")
            }
        }
    }
}
