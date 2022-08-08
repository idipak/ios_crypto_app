//
//  Crypto_AppApp.swift
//  Crypto App
//
//  Created by Xcode on 25/07/22.
//

import SwiftUI

@main
struct Crypto_AppApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
