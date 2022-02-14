//
//  NoItemsView.swift
//  TodoList
//
//  Created by Nick Sarno on 3/3/21
//  Adapted by Larry Burris on 2/14/2022
//
import SwiftUI

struct NoItemsView: View
{
    @EnvironmentObject var listViewModel: ListViewModel
    
    @State var animate: Bool = false
    @State private var isShowingAlert = false
    @State private var alertInput = ""

    let secondaryAccentColor = Color("SecondaryAccentColor")

    var body: some View
    {
        ScrollView
        {
            VStack(spacing: 10)
            {
                Text("There are no items to display!")
                    .font(.title3)
                    .fontWeight(.semibold)

                NavigationLink(
                    destination: AddView(),
                    label: {
                        Text("Add New Item")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    })
                    .padding(.horizontal, 50)
                    .shadow(
                        color: Color.accentColor.opacity(0.7),
                        radius: 10,
                        x: 0,
                        y: 30)
            }
            .frame(maxWidth: 400)
            .multilineTextAlignment(.center)
            .padding(40)
            .onAppear(perform: checkUserNameStatus)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .textFieldAlert(isShowing: $isShowingAlert, text: $alertInput, title: "Please Enter Your Name To Identify Items!")
        
        Spacer()
    }
    
    func checkUserNameStatus()
    {
        if listViewModel.userName == "Anonymous"
        {
            isShowingAlert = true
        }
    }

    func addAnimation()
    {
        guard !animate else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
        {
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
                    .repeatForever()
            )
            {
                animate.toggle()
            }
        }
    }
}

struct TextFieldAlert<Presenting>: View where Presenting: View
{
    @EnvironmentObject var listViewModel: ListViewModel
    
    @Binding var isShowing: Bool
    @Binding var text: String
    
    let presenting: Presenting
    let title: String
    
    func saveUserName()
    {
        Log.info("User name value to be saved from text field alert is: \(text)")
        
        listViewModel.saveUserNameInformation(text)
    }

    var body: some View
    {
        GeometryReader
        {
            (_: GeometryProxy) in

            ZStack
            {
                self.presenting.disabled(isShowing)
                
                VStack
                {
                    Text(self.title)
                    
                    TextField("Anonymous", text: $text)
                        .padding(.horizontal)
                        .frame(height: 55)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    HStack
                    {
                        Button(action:
                        {
                            withAnimation
                            {
                                saveUserName()
                                isShowing.toggle()
                            }
                        })
                        {
                            Text("Save")
                        }
                        
                        Button("Cancel", role: .cancel, action:
                        {
                            withAnimation
                            {
                                isShowing.toggle()
                            }
                        })
                    }
                }
                .frame(maxWidth: 400)
                .padding()
                .shadow(radius: 5)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}

struct NoItemsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        NavigationView
        {
            NoItemsView()
                .navigationTitle("Title")
        }
        .preferredColorScheme(.dark)
    }
}

extension View
{
    func textFieldAlert(isShowing: Binding<Bool>, text: Binding<String>, title: String) -> some View
    {
        TextFieldAlert(isShowing: isShowing, text: text, presenting: self, title: title)
    }
}
