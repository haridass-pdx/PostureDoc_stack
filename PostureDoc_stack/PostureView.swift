//
//  PostureView.swift
//  PostureDoc_stack
//
//  Created by Hari Dass Khalsa on 3/1/26.
//

import SwiftUI



struct PostureView: View {
@EnvironmentObject  var globalData: globalDataRec
@Binding  var item: PostureAnalysis
var frontPoints: PointList = PointList()
var sidePoints: PointList = PointList()
var topMark: ThePoint = ThePoint(name: topMarkName, position: CGPoint(x: 0, y: 0),
                                            containRect: CGRect(x: 0, y: 0, width: 0, height: 225), dragAllowed: .yonly)
var bottomMark: ThePoint = ThePoint(name: bottomMarkName, position: CGPoint(x: 0, y: 450),
                                               containRect: CGRect(x: 0, y: 225, width: 0, height: 225), dragAllowed: .yonly)

let pWIdth: CGFloat = 300
let pHeight: CGFloat = 450

init(item: Binding<PostureAnalysis>) {
    _item = item
    setFrontPoints()
    setSidePoints()
    readPoints()
}

mutating  func setSidePoints(){
    var headPt = ThePoint(name: sidePtNames.headSide.rawValue, position: CGPoint(x: pWIdth / 2, y: 25), containRect: CGRect(x: pWIdth / 3, y: 10, width: pWIdth / 3, height: 75), dragAllowed: .both)

    var shoulderPt = ThePoint(name: sidePtNames.shoulder.rawValue, position: CGPoint(x: pWIdth / 2, y: 100), containRect: CGRect(x: pWIdth / 3, y: 100, width: pWIdth / 3, height: 100), dragAllowed: .both)

    var hipPt = ThePoint(name: sidePtNames.hip.rawValue, position: CGPoint(x: pWIdth / 2, y: 250), containRect: CGRect(x: pWIdth / 3, y: 200, width: pWIdth / 3, height: 100), dragAllowed: .both)
   
    var kneePt = ThePoint(name: sidePtNames.knee.rawValue, position: CGPoint(x: pWIdth / 2, y: 325), containRect: CGRect(x: pWIdth / 3, y: 275, width: pWIdth / 3, height: 100), dragAllowed: .both)

    var anklePt = ThePoint(name: sidePtNames.ankle.rawValue, position: CGPoint(x: pWIdth / 2, y: 400), containRect: CGRect(x: pWIdth / 3, y: 350, width: pWIdth / 3, height: 100), dragAllowed: .both)
    
    headPt.nextPoint = shoulderPt
    shoulderPt.nextPoint = hipPt
    hipPt.nextPoint = kneePt
    kneePt.nextPoint = anklePt
    
    sidePoints.append(topMark)
    sidePoints.append(bottomMark)
    
    sidePoints.append(headPt)
    sidePoints.append(shoulderPt)
    sidePoints.append(hipPt)
    sidePoints.append(kneePt)
  sidePoints.append(anklePt)
    
}

mutating  func setFrontPoints(){
    
    frontPoints.append(topMark)
    frontPoints.append(bottomMark)
   
    var headPt = ThePoint(name: frontPtNames.head.rawValue, position: CGPoint(x: pWIdth / 2, y: 50), containRect: CGRect(x: pWIdth / 3, y: 10, width: pWIdth / 3, height: 100), dragAllowed: .both)
    
    
    frontPoints.append(headPt)
    
    var heartPt = ThePoint(name: frontPtNames.heart.rawValue, position: CGPoint(x: pWIdth / 2, y: 150), containRect: CGRect(x: pWIdth / 3, y: 100, width: pWIdth / 3, height: 100), dragAllowed: .both)
    headPt.nextPoint = heartPt
    frontPoints.append(heartPt)

    var navelPt = ThePoint(name: frontPtNames.navel.rawValue, position: CGPoint(x: pWIdth / 2, y: 200), containRect: CGRect(x: pWIdth / 3, y: 150, width: pWIdth / 3, height: 100), dragAllowed: .both)
    heartPt.nextPoint = navelPt
    frontPoints.append(navelPt)
    
    var footPt = ThePoint(name: frontPtNames.feet.rawValue, position: CGPoint(x: pWIdth / 2, y: pHeight - 50), containRect: CGRect(x: pWIdth / 3, y: pHeight - 100, width: pWIdth / 3, height: 100), dragAllowed: .both)
    navelPt.nextPoint = footPt
    frontPoints.append(footPt)
    
    var rtShoulderPt = ThePoint(name: frontPtNames.rtShoulder.rawValue, position: CGPoint(x: pWIdth / 3, y: 120), containRect: CGRect(x: pWIdth / 5, y: 90, width: pWIdth / 5, height: 50), dragAllowed: .both)

    frontPoints.append(rtShoulderPt)
    
    var ltShoulderPt = ThePoint(name: frontPtNames.ltShoulder.rawValue, position: CGPoint(x: pWIdth * 2 / 3, y: 120), containRect: CGRect(x: pWIdth * 3 / 5, y: 90, width: pWIdth / 5, height: 50), dragAllowed: .both)
    rtShoulderPt.nextPoint = ltShoulderPt
    frontPoints.append(ltShoulderPt)
    
    var rtHipPt = ThePoint(name: frontPtNames.rtHip.rawValue, position: CGPoint(x: pWIdth / 2.5, y: 210), containRect: CGRect(x: pWIdth / 4, y: 190, width: pWIdth / 4, height: 70), dragAllowed: .both)

    frontPoints.append(rtHipPt)
    
    var ltHipPt = ThePoint(name: frontPtNames.ltHip.rawValue, position: CGPoint(x: pWIdth * 2 / 3, y: 210), containRect: CGRect(x: pWIdth  / 2, y: 190, width: pWIdth / 4, height: 70), dragAllowed: .both)
    
    rtHipPt.nextPoint = ltHipPt
    frontPoints.append(ltHipPt)


}

  func readPoints(){
    
         for point in item.sidePoints {
             if let foundPoint = sidePoints.points.firstIndex(where:{ $0.name == point.ptname}){
                 sidePoints.points[foundPoint].position = CGPoint(x: point.ptlocation.x, y: point.ptlocation.y)
             }
            
        }
    
    for point in item.frontPoints {
        if let foundPoint = frontPoints.points.firstIndex(where:{ $0.name == point.ptname}){
            frontPoints.points[foundPoint].position = CGPoint(x: point.ptlocation.x, y: point.ptlocation.y)
        }

   }

}

func savePoints(){
    
    for point in frontPoints.points {
        let loc = location(x: point.position.x, y: point.position.y)
      if let foundPoint = item.frontPoints.firstIndex(where:{ $0.ptname == point.name}){
            item.frontPoints[foundPoint].ptlocation = loc
        }
        else{
            var newPoint = PosturePoint(ptname: point.name, ptlocation: loc)
            item.frontPoints.append(newPoint)
            
        }
    }
    
    for point in sidePoints.points {
        let loc = location(x: point.position.x, y: point.position.y)
      if let foundPoint = item.sidePoints.firstIndex(where:{ $0.ptname == point.name}){
            item.sidePoints[foundPoint].ptlocation = loc
        }
        else{
            var newPoint = PosturePoint(ptname: point.name, ptlocation: loc)
            item.sidePoints.append(newPoint)
            
        }
    }


}


var body: some View {
    VStack {
        Text("Posture Analysis")
            .font(.title)
            .bold()
        NavigationLink("Analysis View") {
            
            let height: CGFloat = globalData.nameRec?.height ?? 0
            AnalysisView(PAItem: $item,
                         frontPoints: frontPoints,
                         sidePoints: sidePoints,
                         height: height)
            .environmentObject(globalData)
        }

        Form {
            TextField("Enter Date:", value: $item.date,  format: .dateTime.day().month().year())
        }
        .padding(10)
                //.disabled(false)
        .padding(10)
        HStack {
            ImageView(
                thePicture: $item.frontImage,
                thisView: "Front",
                thePoints: frontPoints                )
            
            ImageView(thePicture: $item.sideImage,
                      thisView: "Side",
                      thePoints: sidePoints)
        }
    }.onAppear(){
        
       // readPoints()
        
    }
    .onDisappear {
        savePoints()
    }
    .navigationTitle("Posture Edit")
}
}

#Preview {
//PostureView()
}

