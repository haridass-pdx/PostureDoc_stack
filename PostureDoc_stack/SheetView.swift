//
//  SheetView.swift
//  PostureDoc_stack
//
//  Created by Hari Dass Khalsa on 3/1/26.
//

import SwiftUI

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
#Preview {
   // SheetView()
}
