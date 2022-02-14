//
//  ListRowView.swift
//  TodoList
//
//  Created by Nick Sarno on 3/2/21
//  Adapted by Larry Burris on 2/14/2022
//
import SwiftUI

struct ListRowView: View
{
    @EnvironmentObject var listViewModel: ListViewModel
    
    let toDoItem: ToDoItem

    var body: some View
    {
        VStack(alignment: .leading, spacing: 10)
        {
            HStack
            {
                Image(systemName: toDoItem.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(toDoItem.isCompleted ? .green : .accentColor)
                
                Text(toDoItem.title)
            }
            .font(.callout)
            
            Text(toDoItem.descriptionText).font(.caption).padding(.horizontal, 20).foregroundColor(.secondary)
            
            Text("Created by \(toDoItem.createdBy) on \(toDoItem.dateCreated)").font(.caption).padding(.horizontal, 20).foregroundColor(.secondary)
            
            if(toDoItem.isCompleted)
            {
                Text("Item completed on \(toDoItem.lastUpdated)").font(.caption).padding(.horizontal, 20).foregroundColor(.secondary)
            }
        }
    }
}
