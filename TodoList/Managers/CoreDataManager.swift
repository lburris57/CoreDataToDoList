//
//  CoreDataManager.swift
//  SwiftUI Requirements and Specifications
//
//  Created by Larry Burris on 10/21/21.
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
