//
//  CircleButtonAnimation.swift
//  Crypto App
//
//  Created by Xcode on 25/07/22.
//

import SwiftUI

struct CircleButtonAnimation: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
            .scale(animate ? 1.0 : 0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeOut(duration: 1) : .none)
            .onAppear{
                animate.toggle()
            }
    }
}

struct CircleButtonAnimation_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimation(animate: .constant(false))
            .foregroundColor(.red)
            .frame(width: 100, height: 100)
    }
}
