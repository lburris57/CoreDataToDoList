//
//  TodoListApp.swift
//  TodoList
//
//  Created by Larry Burris on 02/14/22.
//  Copyright © 2022 Larry Burris. All rights reserved.
//
import SwiftUI

@main
struct TodoListApp: App
{
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    
    let persistentContainer = CoreDataManager.shared.persistentContainer

    var body: some Scene
    {
        WindowGroup
        {
            NavigationView
            {
                ListView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(listViewModel)
            .environment(\.managedObjectContext, persistentContainer.viewContext)
            .onAppear
            {
                UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            }
        }
    }
}

