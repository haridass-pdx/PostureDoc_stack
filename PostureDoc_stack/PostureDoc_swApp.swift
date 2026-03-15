//
//  PostureDoc_swApp.swift
//  PostureDoc_sw
//
//  Created by Hari Dass Khalsa on 2/20/26.
//

import SwiftUI
import SwiftData
internal import Combine

class globalDataRec: ObservableObject{
    
    @Published   var nameRec: Item? = nil
    @Published   var nameStr  = "Test"
}

@main
struct PostureDoc_swApp: App {
    @StateObject private var globalData = globalDataRec()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(globalData)
        }
        .modelContainer(sharedModelContainer)
    }
    init() {
            print(URL.applicationSupportDirectory.path(percentEncoded: false))
        }

}
