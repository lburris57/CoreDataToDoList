//
//  NeumorphicButtonStyle.swift
//  TodoList
//
//  Created by Larry Burris on 02/14/22.
//  Copyright © 2022 Larry Burris. All rights reserved.
//
import SwiftUI

struct NeumorphicButtonStyle: ButtonStyle
{
    func makeBody(configuration: Configuration) -> some View
    {
        configuration.label.background(
            
        Group
        {
            if configuration.isPressed
            {
                withAnimation
                {
                    Capsule()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .shadow(color: Color.accentColor.opacity(0.3), radius: 10, x: 3, y: 3)
                        .background(Color.accentColor.opacity(0.7))
                        .clipShape(Capsule())
                        .shadow(color: Color.accentColor.opacity(0.3), radius: 10, x: -2, y: -2)
                        .clipShape(Capsule())
                        .scaleEffect(0.95)
                }
            }
            else
            {
                withAnimation
                {
                    Capsule()
                        .fill(Color.accentColor)
                        .shadow(color: Color.accentColor.opacity(0.2), radius: 10, x: 2, y: 2)
                        .shadow(color: Color.accentColor.opacity(0.7), radius: 10, x: -2, y: -2)
                }
            }
        })
    }
}

struct NeumorphicButtonStyle_Previews: PreviewProvider
{
    static var previews: some View
    {
        VStack()
        {
            Button("    Display Player Statistics    ")
            {
                
            }.buttonStyle(NeumorphicButtonStyle()).foregroundColor(.white).padding()
        }
    }
}
