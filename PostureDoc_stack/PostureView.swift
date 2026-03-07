//
//  PostureView.swift
//  PostureDoc_stack
//
//  Created by Hari Dass Khalsa on 3/1/26.
//

import SwiftUI

struct PostureView: View {
    @Bindable var item: PostureAnalysis
    var body: some View {
        VStack {
            Text("Posture Analysis")
                .font(.title)
                .bold()
            Form {
                TextField("Enter Date:", value: $item.date,  format: .dateTime.day().month().year())
            }
            
            HStack {
                ImageView(
                    thePicture: $item.frontImage,
                    thisView: "Front"
                )
                
                ImageView(thePicture: $item.sideImage, thisView: "Side")
            }
        }
        .onDisappear {
            
        }
        .navigationTitle("Posture Edit")
    }
}

#Preview {
    //PostureView()
}

