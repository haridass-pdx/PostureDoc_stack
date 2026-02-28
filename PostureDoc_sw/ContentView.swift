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
    
    private struct DetailView : View {
        @Bindable var item: Item
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack{   TextField("First Name:", text: $item.firstname)
                        .textFieldStyle(.roundedBorder)
                    TextField("Last Name:", text: $item.lastname)
                        .textFieldStyle(.roundedBorder)
                    
                }
                HStack{
                    TextField("Gender", text: $item.gender)
                        .textFieldStyle(.roundedBorder)
                    TextField("Height", value: $item.height, format: .number)
                        .textFieldStyle(.roundedBorder)
                }
                Spacer()
                HStack {
                    ImageView(
                        thePicture: Binding<ImageRec?>(
                            get: { item.postureAnalysis.count > 0 ? item.postureAnalysis[0].sideImage : nil },
                            set: { newValue in
                                if let value = newValue { item.postureAnalysis[0].sideImage = value }
                            }
                        ),
                        thisView: "Front"
                    )
                    
                    ImageView(thePicture: Binding<ImageRec?>(
                        get: { item.postureAnalysis.count > 0 ? item.postureAnalysis[0].frontImage : nil },
                        set: { newValue in
                            if let value = newValue { item.postureAnalysis[0].frontImage = value }
                        }
                    ), thisView: "Side")
                }.padding(10)
            }
            .padding()
        }
    }
    
    
    struct sheetView: View{
        @Environment(\.dismiss) var dismiss
        @Binding private var scale: Double
        @Binding private var rotation: Double
        @Binding private var translation: CGSize
        
        init(scale: Binding<Double>, rotation: Binding<Double>, translation: Binding<CGSize>) {
            _scale = scale
            _rotation = rotation
            _translation = translation
        }
        
        var body: some View{
            NavigationStack {
                
                VStack{
                    Text("Scale")
                    Slider(value: $scale, in: 0...3)
                    Text("Rotation")
                    Slider(value: $rotation, in: -4...4)
                    Text("Translation (x / y)")
                    Slider(value: $translation.width, in: -100...100)
                    Slider(value: $translation.height, in: -100...100)
                    
                }
                .frame(maxWidth: 400, maxHeight: .infinity)
                .padding(20)
                Button("Close"){
                    dismiss()
                }
                                .padding(20)
            }
            .presentationDetents([.medium, .large]) // Allows dragging between half and full screen
            .presentationDragIndicator(.visible) // Show

            
        }
    }
    
    private struct ImageView: View{
        @Binding var thePicture: ImageRec?
        @State var theView: String
        @State private var selectedItem: PhotosPickerItem? = nil
        @State private var showingSheet: Bool = false
        @State private var scale = 1.0
        @State private var rotation: Double = 0.0
        @State private var translation: CGSize = .zero
        
        
        let pWIdth: CGFloat = 300
        let pHeight: CGFloat = 450
        
        init(thePicture: Binding<ImageRec?>,
             thisView: String) {
            _thePicture = thePicture
            _theView = State(initialValue: thisView)
        }
        
        var body: some View {
            let transform = CGAffineTransform(scaleX: scale, y: scale)
                .rotated(by: rotation) // Rotates by 45 degrees (radians)
                .translatedBy(x: translation.width, y: translation.height) // Translates by 50 points
            
            
            VStack{
                ZStack{
                    if let data = thePicture?.image, let theImage = NSImage(data: data) {
                        Image(nsImage: theImage)
                            .resizable()
                            .scaledToFit() // or .scaledToFill()
                            .transformEffect(transform)
                            .frame(width: pWIdth, height: pHeight)
                            .clipped() 
                            .border(Color.secondary, width: 2)
                            .shadow(radius: 10)
                    }else{
                        Text("No Image")
                            .frame(width: pWIdth, height: pHeight)
                            .border(Color.secondary, width: 2)
                            .shadow(radius: 10)
                    }
                    PostureMarks(whichPostureView: theView)
                        .frame(width: pWIdth, height: pHeight)
                }
                PhotosPicker("Select a \(theView) view photo", selection: $selectedItem, matching: .images, photoLibrary: .shared())
                    .onChange(of: selectedItem) { _, newItem in
                        guard let newItem else { return }
                        Task {
                            do {
                                if let data = try await newItem.loadTransferable(type: Data.self) {
                                    thePicture?.image = data
                                }
                            } catch {
                                // Handle loading error if necessary
                                print("Failed to load image data: \(error)")
                            }
                        }
                    }
                
                    .padding(10)
                Button("Edit") {
                    showingSheet = true
                }
                
            }
            .sheet(isPresented: $showingSheet) {
                // The content of the sheet is defined here
                sheetView(scale: $scale,
                          rotation: $rotation,
                          translation: $translation)
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

