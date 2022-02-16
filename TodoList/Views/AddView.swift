//
//  AddView.swift
//  TodoList
//
//  Created by Larry Burris on 02/14/22.
//  Copyright © 2022 Larry Burris. All rights reserved.
//
import SwiftUI
import Introspect

struct AddView: View
{
    // MARK: PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    @State var title: String = ""
    @State var description: String = ""
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false

    // MARK: -
    // MARK: BODY
    var body: some View
    {
        ScrollView
        {
            VStack(alignment: .leading, spacing: 20)
            {
                TextField("Please enter a title...", text: $title)
                    .introspectTextField { textField in textField.becomeFirstResponder()}
                    .padding(.horizontal)
                    .frame(maxWidth: 400)
                    .frame(height: 55)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                
                VStack(alignment: .leading)
                {
                    Text(" Enter Description:")
                    
                    TextEditor(text: $description)
                    .padding(.horizontal)
                    .lineLimit(10)
                    .frame(maxWidth: 400)
                    .frame(height: 125)
                    .background(Color(UIColor.secondarySystemBackground))
                    .border(Color.accentColor, width: 1)
                }

                Button(action: saveButtonPressed, label:
                {
                    Text("Save")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: 400)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .shadow(
                            color:Color.accentColor.opacity(0.7),
                            radius: 20,
                            x: 0,
                            y: 20)
                        
                }).disabled(!validateFields())
            }
            .padding(14)
        }
        .navigationTitle("Add Item")
        .alert(isPresented: $showAlert, content: getAlert)
    }

    // MARK: -
    // MARK: FUNCTIONS
    func saveButtonPressed()
    {
        listViewModel.addToDoItem(title: title, description: description)
        presentationMode.wrappedValue.dismiss()
    }

    func validateFields() -> Bool
    {
        if title == "" || description == ""
        {
            return false
        }
        
        return true
    }

    func getAlert() -> Alert
    {
        return Alert(title: Text(alertTitle))
    }
}

// MARK: -
// MARK: PREVIEW
struct AddView_Previews: PreviewProvider
{
    static var previews: some View
    {
        Group
        {
            NavigationView
            {
                AddView()
            }
            .preferredColorScheme(.light)
            .environmentObject(ListViewModel())
            
            NavigationView
            {
                AddView()
            }
            .preferredColorScheme(.dark)
            .environmentObject(ListViewModel())
        }
    }
}
