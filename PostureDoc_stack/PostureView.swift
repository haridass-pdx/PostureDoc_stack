//
//  PostureView.swift
//  PostureDoc_stack
//
//  Created by Hari Dass Khalsa on 3/1/26.
//

import SwiftUI



struct PostureView: View {
 @Binding  var item: PostureAnalysis
    var frontPoints: PointList = PointList()
    var sidePoints: PointList = PointList()
    let pWIdth: CGFloat = 300
    let pHeight: CGFloat = 450
    
    init(item: Binding<PostureAnalysis>) {
        _item = item
        setFrontPoints()
    }
    
    mutating  func setFrontPoints(){
        var headPt = ThePoint(name: "Head", position: CGPoint(x: pWIdth / 2, y: 50), containRect: CGRect(x: pWIdth / 3, y: 10, width: pWIdth / 3, height: 100), dragAllowed: .both)
        
        
        frontPoints.append(headPt)
        
        var heartPt = ThePoint(name: "Heart", position: CGPoint(x: pWIdth / 2, y: 150), containRect: CGRect(x: pWIdth / 3, y: 100, width: pWIdth / 3, height: 100), dragAllowed: .both)
        headPt.nextPoint = heartPt
        frontPoints.append(heartPt)
   
        var navelPt = ThePoint(name: "Navel", position: CGPoint(x: pWIdth / 2, y: 200), containRect: CGRect(x: pWIdth / 3, y: 150, width: pWIdth / 3, height: 100), dragAllowed: .both)
        heartPt.nextPoint = navelPt
        frontPoints.append(navelPt)
        
        var footPt = ThePoint(name: "Feet", position: CGPoint(x: pWIdth / 2, y: pHeight - 50), containRect: CGRect(x: pWIdth / 3, y: pHeight - 100, width: pWIdth / 3, height: 100), dragAllowed: .both)
        navelPt.nextPoint = footPt
        frontPoints.append(footPt)
        
        var rtShoulderPt = ThePoint(name: "Rt Shoulder", position: CGPoint(x: pWIdth / 3, y: 120), containRect: CGRect(x: pWIdth / 5, y: 90, width: pWIdth / 5, height: 50), dragAllowed: .both)

        frontPoints.append(rtShoulderPt)
        
        var ltShoulderPt = ThePoint(name: "Lt Shoulder", position: CGPoint(x: pWIdth * 2 / 3, y: 120), containRect: CGRect(x: pWIdth * 3 / 5, y: 90, width: pWIdth / 5, height: 50), dragAllowed: .both)
        rtShoulderPt.nextPoint = ltShoulderPt
        frontPoints.append(ltShoulderPt)
        
        var rtHipPt = ThePoint(name: "Rt hip", position: CGPoint(x: pWIdth / 2.5, y: 210), containRect: CGRect(x: pWIdth / 4, y: 190, width: pWIdth / 4, height: 70), dragAllowed: .both)

        frontPoints.append(rtHipPt)
        
        var ltHipPt = ThePoint(name: "Lt Hip", position: CGPoint(x: pWIdth * 2 / 3, y: 210), containRect: CGRect(x: pWIdth  / 2, y: 190, width: pWIdth / 4, height: 70), dragAllowed: .both)
        
        rtHipPt.nextPoint = ltHipPt
        // ltHipPt.prevPoint = rtHipPt
        frontPoints.append(ltHipPt)


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

