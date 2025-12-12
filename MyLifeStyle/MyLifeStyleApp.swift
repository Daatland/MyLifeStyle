//
//  MyLifeStyleApp.swift
//  MyLifeStyle
//
//  Created by Marcus Olsen Daatland on 17/09/2025.
//

import SwiftUI
import SwiftData

@main
struct MyLifeStyleApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .modelContainer(for: [Exercise.self, Nutrition.self])
    }
}
