//
//  DetailView.swift
//  PostureDoc_stack
//
//  Created by Hari Dass Khalsa on 3/1/26.
//

import SwiftUI
import SwiftData
import Foundation
import AppKit
import PhotosUI

struct DetailView : View {
    @EnvironmentObject  var globalData: globalDataRec
    @Environment(\.modelContext) private var modelContext
    @Bindable var item: Item
    
//    init(item: Bindable<Item>){
//        _item = item
//        globalData.nameRec = item.wrappedValue
//    }
    
    var body: some View {
        NavigationStack {
            
            
            
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
                Text("Posture List")
                    .font(Font.headline.bold())
                
                HStack{
                    //   Text("Posture Analysis:")
                    List($item.postureAnalysis) { $posture in
                        NavigationLink(posture.date.formatted(date: .abbreviated, time: .omitted)) {
                            PostureView(item: $posture)
                                .environmentObject(globalData)

                        }
                    }
                    
                    
                    
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button(action: {
                            print("Button tapped")
                            addPosture()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .navigationTitle("Posture List")
            }
        }
    }
     func addPosture(){
         
         let newItem = PostureAnalysis(date: Date())
         
         item.postureAnalysis.append(newItem)
         
         modelContext.insert(newItem)

     }
}
#Preview {
   // DetailView()
}

