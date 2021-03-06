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

enum SortOrder: String, Identifiable, CaseIterable, Hashable
{
    var id: UUID
    {
        return UUID()
    }

    case ascending = "Ascending"
    case descending = "Descending"
}

extension SortOrder
{
    var sortOrder: String
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
    @State private var selectedSortOrder: SortOrder = .ascending
    @State private var isAscending: Bool = true
    @State private var toggleIcon: Bool = false

    func filterToDoItems()
    {
        listViewModel.filterToDoItems(searchType: selectedSearchType.searchType, sortOrder: selectedSortOrder.sortOrder)
    }

    func toggleButtonClicked()
    {
        toggleIcon.toggle()
        
        filterToDoItems()
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
                                }
                                .pickerStyle(.menu)
                                .onChange(of: selectedSearchType) { value in filterToDoItems() }

                                Button(action:
                                {
                                    if selectedSortOrder == SortOrder.ascending
                                    {
                                        selectedSortOrder = SortOrder.descending
                                    }
                                    else
                                    {
                                        selectedSortOrder = SortOrder.ascending
                                    }
                                    
                                    toggleButtonClicked()
                                })
                                {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(.blue)
                                        .rotationEffect(.degrees(toggleIcon ? 0.0 : 180.0))
                                        .animation(Animation.linear(duration: 0.2), value: toggleIcon)
                                }

                                Spacer()
                            }
                            .padding(.leading)
                        }
                    }

                    HStack
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
                    listViewModel.toDoItems.isEmpty ? nil : EditButton().foregroundColor(Color.blue)

                    listViewModel.toDoItems.isEmpty ? nil : NavigationLink(destination: AddView())
                    {
                        Label("Add ToDoItem", systemImage: "plus.circle.fill").foregroundColor(.blue)
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
