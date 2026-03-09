//
//  ImageView.swift
//  PostureDoc_stack
//
//  Created by Hari Dass Khalsa on 3/1/26.
//

import SwiftUI
import SwiftData
import Foundation
import AppKit
import PhotosUI

 struct ImageView: View{
    @Binding var thePicture: ImageRec
    @State var theView: String
     @State var thePoints: [ThePoint]
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showingSheet: Bool = false
    @State private var scale = 1.0
    @State private var rotation: Double = 0.0
    @State private var translation: CGSize = .zero
    
    
    let pWIdth: CGFloat = 300
    let pHeight: CGFloat = 450
    
    init(thePicture: Binding<ImageRec>,
         thisView: String,
         thePoints: [ThePoint]) {
        _thePicture = thePicture
        _theView = State(initialValue: thisView)
        _rotation = State(initialValue: thePicture.wrappedValue.rotation)
        _scale = State(initialValue: thePicture.wrappedValue.scale)
        let tSize: CGSize = .init(width: thePicture.wrappedValue.translation.x, height: thePicture.wrappedValue.translation.y)
        _translation = State(initialValue: tSize)
        _thePoints  = State(initialValue: thePoints)
    }
    
    var body: some View {
        let transform = CGAffineTransform(scaleX: scale, y: scale)
            .rotated(by: rotation) // Rotates by 45 degrees (radians)
            .translatedBy(x: translation.width, y: translation.height) // Translates by 50 points
        
        
        VStack{
            ZStack{
                if let data = thePicture.image, let theImage = NSImage(data: data) {
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
                
                PostureMarks(whichPostureView: theView,
                             thePoints: thePoints)
                    .frame(width: pWIdth, height: pHeight)
            }
            PhotosPicker("Select a \(theView) view photo", selection: $selectedItem, matching: .images, photoLibrary: .shared())
                .onChange(of: selectedItem) { _, newItem in
                    guard let newItem else { return }
                    Task {
                        do {
                            if let data = try await newItem.loadTransferable(type: Data.self) {
                                thePicture.image = data
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
        .onDisappear {
            thePicture.scale = self.scale
            thePicture.translation.x = self.translation.width
            thePicture.translation.y = self.translation.height  
            thePicture.rotation = self.rotation
        }
        .sheet(isPresented: $showingSheet) {
            // The content of the sheet is defined here
            sheetView(scale: $scale,
                      rotation: $rotation,
                      translation: $translation)
        }
        
    }
    
}
#Preview {
  //  ImageView()
}

