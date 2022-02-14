//
//  ListView.swift
//  TodoList
//
//  Created by Nick Sarno on 3/2/21
//  Adapted by Larry Burris on 2/14/2022
//
import SwiftUI

struct ListView: View
{
    @EnvironmentObject var listViewModel: ListViewModel

    var body: some View
    {
        ZStack
        {
            if listViewModel.toDoItems.isEmpty
            {
                NoItemsView().transition(AnyTransition.opacity.animation(.easeIn))
            }
            else
            {
                HStack()
                {
                    List
                    {
                        ForEach(listViewModel.toDoItems)
                        {
                            item in
                            
                            ListRowView(toDoItem: item)
                                .onTapGesture
                                {
                                    withAnimation(.linear)
                                    {
                                        listViewModel.updateItem(toDoItem: item)
                                    }
                                }
                        }
                        .onDelete(perform: listViewModel.deleteItem)
                        .onMove(perform: listViewModel.moveItem)
                    }
                    .frame(maxWidth: 800)
                    .listStyle(PlainListStyle())
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("To Do Items")
        .navigationBarItems(
            leading: listViewModel.toDoItems.isEmpty ? nil : EditButton(),
            trailing:
                listViewModel.toDoItems.isEmpty ? nil : NavigationLink("Add", destination: AddView())
        )
    }
}

struct ListView_Previews: PreviewProvider
{
    static var previews: some View
    {
        NavigationView
        {
            ListView()
        }
        .preferredColorScheme(.dark)
        .environmentObject(ListViewModel())
    }
}
