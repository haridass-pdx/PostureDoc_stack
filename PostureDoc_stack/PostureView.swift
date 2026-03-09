//
//  PostureView.swift
//  PostureDoc_stack
//
//  Created by Hari Dass Khalsa on 3/1/26.
//

import SwiftUI



struct PostureView: View {
    @Bindable var item: PostureAnalysis
    var frontPoints: [ThePoint] = []
    var sidePoints: [ThePoint] = []
    let pWIdth: CGFloat = 300
    let pHeight: CGFloat = 450
    
    init(item: PostureAnalysis) {
        self.item = item
        setFrontPoints()
    }
    
    mutating  func setFrontPoints(){
        let headPt = ThePoint(name: "Head", position: CGPoint(x: pWIdth / 2, y: 50), containRect: CGRect(x: pWIdth / 3, y: 10, width: pWIdth / 3, height: 100), dragAllowed: .both)
        
        
        frontPoints.append(headPt)
        
        let heartPt = ThePoint(name: "Heart", position: CGPoint(x: pWIdth / 2, y: 150), containRect: CGRect(x: pWIdth / 3, y: 100, width: pWIdth / 3, height: 100), dragAllowed: .both)

        frontPoints.append(heartPt)
   
        let navelPt = ThePoint(name: "Navel", position: CGPoint(x: pWIdth / 2, y: 200), containRect: CGRect(x: pWIdth / 3, y: 150, width: pWIdth / 3, height: 100), dragAllowed: .both)

        frontPoints.append(navelPt)
        
        let footPt = ThePoint(name: "Feet", position: CGPoint(x: pWIdth / 2, y: pHeight - 50), containRect: CGRect(x: pWIdth / 3, y: pHeight - 100, width: pWIdth / 3, height: 100), dragAllowed: .both)

        frontPoints.append(footPt)
        
        let rtShoulderPt = ThePoint(name: "Rt Shoulder", position: CGPoint(x: pWIdth / 3, y: 120), containRect: CGRect(x: pWIdth / 5, y: 90, width: pWIdth / 5, height: 50), dragAllowed: .both)

        frontPoints.append(rtShoulderPt)
        
        let ltShoulderPt = ThePoint(name: "Lt Shoulder", position: CGPoint(x: pWIdth * 2 / 3, y: 120), containRect: CGRect(x: pWIdth * 3 / 5, y: 90, width: pWIdth / 5, height: 50), dragAllowed: .both)

        frontPoints.append(ltShoulderPt)
        
  

    }
    
    
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
                    thisView: "Front",
                    thePoints: frontPoints                )
                
                ImageView(thePicture: $item.sideImage,
                          thisView: "Side",
                          thePoints: sidePoints)
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

