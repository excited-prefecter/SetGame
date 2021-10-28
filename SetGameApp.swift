//
//  SetGameApp.swift
//  SetGame
//
//  Created by Chaoxin Zhang on 2021/1/10.
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
