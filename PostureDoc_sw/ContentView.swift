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
                Text(item.name)
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

    private struct DetailView: View {
        @Bindable var item: Item

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                TextField("Name:", text: $item.name)
                    .textFieldStyle(.roundedBorder)
                Text("ID: \(item.id.uuidString)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    Spacer()
                HStack {
                    ImageView(thePicture: $item.frontImage,
                              thisView: "Front")
                    
                    ImageView(thePicture: $item.sideImage,
                              thisView: "Side")
                }.padding(10)
            }
            .padding()
        }
    }
    
    
    private struct ImageView: View{
        @Binding var thePicture: Data?
        @State var theView: String
        @State private var selectedItem: PhotosPickerItem? = nil
        let pWIdth: CGFloat = 300
        let pHeight: CGFloat = 450
        
        init(thePicture: Binding<Data?>,
             thisView: String) {
           _thePicture = thePicture
            _theView = State(initialValue: thisView)
        }
        
        var body: some View {
            VStack{
                if let data = thePicture, let theImage = NSImage(data: data) {
                    Image(nsImage: theImage)
                    .resizable()
                    .scaledToFit() // or .scaledToFill()
                    .frame(width: pWIdth, height: pHeight)
                    .border(Color.secondary, width: 2)
                    .shadow(radius: 10)
                }else{
                   Text("No Image")
                        .frame(width: pWIdth, height: pHeight)
                        .border(Color.secondary, width: 2)
                        .shadow(radius: 10)
                }
                 
                PhotosPicker("Select a \(theView) view photo", selection: $selectedItem, matching: .images, photoLibrary: .shared())
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                thePicture = data
                                if let uiImage = NSImage(data: data) {
                                    // Update your UI with the selected UIImage
                                }
                            }
                        }
                    }


                                
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

