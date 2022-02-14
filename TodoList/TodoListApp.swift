//
//  TodoListApp.swift
//  TodoList
//
//  Created by Nick Sarno on 3/2/21
//  Adapted by Larry Burris on 2/14/2022
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
