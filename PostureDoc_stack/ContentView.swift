//
//  ContentView.swift
//  PostureDoc_sw
//
//  Created by Hari Dass Khalsa on 2/20/26.
//

import SwiftUI
import SwiftData
import Foundation
import AppKit
import PhotosUI


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var itemCount: Int = 0
    @State private var selection: Item.ID?
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        NavigationSplitView {
            List(items, selection: $selection) { item in
                HStack{
                    Text(item.firstname)
                    Text(item.lastname)
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            if let selected = items.first(where: { $0.id == selection }) {
                DetailView(item: selected)
            } else {
                Text("Select an item")
            }
        }
        .onAppear {
            itemCount = items.count + 1
            // Initialize selection to first item if available
            if selection == nil { selection = items.first?.id }
        }
        .onChange(of: items) { _, newItems in
            itemCount = newItems.count + 1
            // Keep selection valid when items change
            if let sel = selection, !newItems.contains(where: { $0.id == sel }) {
                selection = newItems.first?.id
            }
        }
    }
    

    
    

    

    
    private func addItem() {
        withAnimation {
            let newItem = Item(theName: "Name \(itemCount)")
            modelContext.insert(newItem)
            // Select the newly added item
            selection = newItem.id
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

