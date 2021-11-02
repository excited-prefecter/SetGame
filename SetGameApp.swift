//
//  SetGameApp.swift
//  SetGame
//
//  Created by *** on 2021/1/10.
//

import SwiftUI

@main
struct SetGameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: SetGameViewModel())
        }
    }
}
