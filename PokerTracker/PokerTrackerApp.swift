//
//  PokerTrackerApp.swift
//  PokerTracker
//
//  Created by Reece on 3/18/24.
//

import SwiftUI
import SwiftData

@main
struct PokerTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: PlayerData.self)
    }
}
