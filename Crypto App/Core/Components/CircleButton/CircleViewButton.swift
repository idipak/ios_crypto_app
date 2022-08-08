//
//  CircleViewButton.swift
//  Crypto App
//
//  Created by Xcode on 25/07/22.
//

import SwiftUI

struct CircleViewButton: View {
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(Color.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.35), radius: 10, x: 0, y: 0)
            .padding()
    }
}

struct CircleViewButton_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            CircleViewButton(iconName: "info")
                .previewLayout(.sizeThatFits)
            
            CircleViewButton(iconName: "plus")
                .previewLayout(.sizeThatFits)
                .colorScheme(.dark)
        }
        
    }
}
