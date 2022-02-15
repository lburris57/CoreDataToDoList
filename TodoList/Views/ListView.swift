//
//  ListView.swift
//  TodoList
//
//  Created by Larry Burris on 02/14/22.
//  Copyright © 2022 Larry Burris. All rights reserved.
//
import SwiftUI

// Enums
enum SearchType: String, Identifiable, CaseIterable, Hashable
{
    var id: UUID
    {
        return UUID()
    }

    case noFilter = "No Filter"
    case notCompleted = "Not Completed"
    case completed = "Completed"
}

extension SearchType
{
    var searchType: String
    {
        switch self
        {
            case .noFilter:
                return "No Filter"
            case .notCompleted:
                return "Not Completed"
            case .completed:
                return "Completed"
        }
    }
}

enum SortType: String, Identifiable, CaseIterable, Hashable
{
    var id: UUID
    {
        return UUID()
    }
    
    case ascending = "Ascending"
    case descending = "Descending"
}

extension SortType
{
    var sortType: String
    {
        switch self
        {
            case .ascending:
                return "Ascending"
            case .descending:
                return "Descending"
        }
    }
}

struct ListView: View
{
    @EnvironmentObject var listViewModel: ListViewModel
    
    @State private var selectedSearchType: SearchType = .noFilter
    @State private var selectedSortType: SortType = .ascending
    @State private var searchText = Constants.EMPTY_STRING
    @State private var sortText = Constants.EMPTY_STRING
    
    func filterToDoItems()
    {
        listViewModel.filterToDoItems(searchType: selectedSearchType.searchType, sortType: selectedSortType.sortType)
    }

    var body: some View
    {
        ZStack
        {
            VStack(alignment: .leading)
            {
                if listViewModel.toDoItems.isEmpty && listViewModel.isFiltered == false
                {
                    NoItemsView().transition(AnyTransition.opacity.animation(.easeIn))
                }
                else
                {
                    if listViewModel.toDoItems.count > 0 || listViewModel.isFiltered == true
                    {
                        VStack(alignment: .leading, spacing: 0)
                        {
                            HStack
                            {
                                Text(" Filter Type:").foregroundColor(Color.secondary)
                                
                                Picker("Search Type", selection: $selectedSearchType)
                                {
                                    ForEach(SearchType.allCases)
                                    {
                                        searchType in

                                        Text(searchType.searchType).tag(searchType)
                                    }
                                }.pickerStyle(.menu)
                                
                                Spacer()
                                
                                Button(action: { filterToDoItems() })
                                {
                                    Label("", systemImage: "mail.stack").foregroundColor(.accentColor)
                                }
                                .padding(.horizontal, 15)
                                
                            }
                            .padding(.leading)
                                
                            if selectedSearchType != SearchType.noFilter
                            {
                                HStack
                                {
                                    Text(" Sort Type:").foregroundColor(Color.secondary)
                                    
                                    Picker("Sort Type", selection: $selectedSortType)
                                    {
                                        ForEach(SortType.allCases)
                                        {
                                            sortType in

                                            Text(sortType.sortType).tag(sortType)
                                        }
                                    }.pickerStyle(.menu)
                                    
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
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
        }
        .navigationTitle("To Do Items")
        .toolbar
        {
            ToolbarItemGroup(placement: .navigationBarTrailing)
            {
                HStack
                {
                    listViewModel.toDoItems.isEmpty ? nil : EditButton()
                        
                    listViewModel.toDoItems.isEmpty ? nil : NavigationLink(destination: AddView())
                    {
                        Label("Add ToDoItem", systemImage: "plus.circle.fill").foregroundColor(.accentColor)
                    }
                }
            }
        }
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
