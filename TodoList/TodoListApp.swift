//
//  TodoListApp.swift
//  TodoList
//
//  Created by Larry Burris on 02/14/22.
//  Copyright © 2022 Larry Burris. All rights reserved.
//
import SwiftUI
import CloudKit

@main
struct TodoListApp: App
{
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    
    let persistentContainer = CoreDataManager.shared.persistentContainer

    var body: some Scene
    {
        WindowGroup
        {
            ListView()
            .environmentObject(listViewModel)
            .environment(\.managedObjectContext, persistentContainer.viewContext)
            .onAppear
            {
                // Disable the UIConstraint to fix bug in Apple's code
                UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            }
        }
    }
}

