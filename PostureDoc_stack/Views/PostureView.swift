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
@State private var frontPoints: PointList
@State private var sidePoints: PointList

static let pWIdth: CGFloat = 300
static let pHeight: CGFloat = 450

init(item: Binding<PostureAnalysis>) {
    _item = item
    
    // Create separate instances for front and side views
    let frontTopMark = ThePoint(name: topMarkName, position: CGPoint(x: 0, y: 0),
                               containRect: CGRect(x: 0, y: 0, width: Self.pWIdth, height: 225), 
                               dragAllowed: .yonly)
    let frontBottomMark = ThePoint(name: bottomMarkName, position: CGPoint(x: 0, y: 450),
                                  containRect: CGRect(x: 0, y: 225, width: Self.pWIdth, height: 225), 
                                  dragAllowed: .yonly)
    
    let sideTopMark = ThePoint(name: topMarkName, position: CGPoint(x: 0, y: 0),
                              containRect: CGRect(x: 0, y: 0, width: Self.pWIdth, height: 225), 
                              dragAllowed: .yonly)
    let sideBottomMark = ThePoint(name: bottomMarkName, position: CGPoint(x: 0, y: 450),
                                 containRect: CGRect(x: 0, y: 225, width: Self.pWIdth, height: 225), 
                                 dragAllowed: .yonly)
    
    let front = Self.createFrontPoints(width: Self.pWIdth, height: Self.pHeight, topMark: frontTopMark, bottomMark: frontBottomMark)
    let side = Self.createSidePoints(width: Self.pWIdth, height: Self.pHeight, topMark: sideTopMark, bottomMark: sideBottomMark)
    
    _frontPoints = State(initialValue: front)
    _sidePoints = State(initialValue: side)
    
    // Load saved positions
    Self.readPoints(from: item.wrappedValue, into: front, and: side)
}

static func createSidePoints(width: CGFloat, height: CGFloat, topMark: ThePoint, bottomMark: ThePoint) -> PointList {
    let points = PointList()
    
    let headPt = ThePoint(name: sidePtNames.headSide.rawValue, 
                         position: CGPoint(x: width / 2, y: 25), 
                         containRect: CGRect(x: width / 3, y: 10, width: width / 3, height: 75), 
                         dragAllowed: .both)

    let shoulderPt = ThePoint(name: sidePtNames.shoulder.rawValue, 
                             position: CGPoint(x: width / 2, y: 100), 
                             containRect: CGRect(x: width / 3, y: 100, width: width / 3, height: 100), 
                             dragAllowed: .both)

    let hipPt = ThePoint(name: sidePtNames.hip.rawValue, 
                        position: CGPoint(x: width / 2, y: 250), 
                        containRect: CGRect(x: width / 3, y: 200, width: width / 3, height: 100), 
                        dragAllowed: .both)
   
    let kneePt = ThePoint(name: sidePtNames.knee.rawValue, 
                         position: CGPoint(x: width / 2, y: 325), 
                         containRect: CGRect(x: width / 3, y: 275, width: width / 3, height: 100), 
                         dragAllowed: .both)

    let anklePt = ThePoint(name: sidePtNames.ankle.rawValue, 
                          position: CGPoint(x: width / 2, y: 400), 
                          containRect: CGRect(x: width / 3, y: 350, width: width / 3, height: 100), 
                          dragAllowed: .both)
    
    headPt.nextPoint = shoulderPt
    shoulderPt.nextPoint = hipPt
    hipPt.nextPoint = kneePt
    kneePt.nextPoint = anklePt
    
    points.append(topMark)
    points.append(bottomMark)
    points.append(headPt)
    points.append(shoulderPt)
    points.append(hipPt)
    points.append(kneePt)
    points.append(anklePt)
    
    return points
}

static func createFrontPoints(width: CGFloat, height: CGFloat, topMark: ThePoint, bottomMark: ThePoint) -> PointList {
    let points = PointList()
    
    points.append(topMark)
    points.append(bottomMark)
   
    let headPt = ThePoint(name: frontPtNames.head.rawValue, 
                         position: CGPoint(x: width / 2, y: 50), 
                         containRect: CGRect(x: width / 3, y: 10, width: width / 3, height: 100), 
                         dragAllowed: .both)
    points.append(headPt)
    
    let heartPt = ThePoint(name: frontPtNames.heart.rawValue, 
                          position: CGPoint(x: width / 2, y: 150), 
                          containRect: CGRect(x: width / 3, y: 100, width: width / 3, height: 100), 
                          dragAllowed: .both)
    headPt.nextPoint = heartPt
    points.append(heartPt)

    let navelPt = ThePoint(name: frontPtNames.navel.rawValue, 
                          position: CGPoint(x: width / 2, y: 200), 
                          containRect: CGRect(x: width / 3, y: 150, width: width / 3, height: 100), 
                          dragAllowed: .both)
    heartPt.nextPoint = navelPt
    points.append(navelPt)
    
    let footPt = ThePoint(name: frontPtNames.feet.rawValue, 
                         position: CGPoint(x: width / 2, y: height - 50), 
                         containRect: CGRect(x: width / 3, y: height - 100, width: width / 3, height: 100), 
                         dragAllowed: .both)
    navelPt.nextPoint = footPt
    points.append(footPt)
    
    let rtShoulderPt = ThePoint(name: frontPtNames.rtShoulder.rawValue, 
                               position: CGPoint(x: width / 3, y: 120), 
                               containRect: CGRect(x: width / 5, y: 90, width: width / 5, height: 50), 
                               dragAllowed: .both)
    points.append(rtShoulderPt)
    
    let ltShoulderPt = ThePoint(name: frontPtNames.ltShoulder.rawValue, 
                               position: CGPoint(x: width * 2 / 3, y: 120), 
                               containRect: CGRect(x: width * 3 / 5, y: 90, width: width / 5, height: 50), 
                               dragAllowed: .both)
    rtShoulderPt.nextPoint = ltShoulderPt
    points.append(ltShoulderPt)
    
    let rtHipPt = ThePoint(name: frontPtNames.rtHip.rawValue, 
                          position: CGPoint(x: width / 2.5, y: 210), 
                          containRect: CGRect(x: width / 4, y: 190, width: width / 4, height: 70), 
                          dragAllowed: .both)
    points.append(rtHipPt)
    
    let ltHipPt = ThePoint(name: frontPtNames.ltHip.rawValue, 
                          position: CGPoint(x: width * 2 / 3, y: 210), 
                          containRect: CGRect(x: width / 2, y: 190, width: width / 4, height: 70), 
                          dragAllowed: .both)
    rtHipPt.nextPoint = ltHipPt
    points.append(ltHipPt)
    
    return points
}

static func readPoints(from item: PostureAnalysis, into frontPoints: PointList, and sidePoints: PointList) {
    for point in item.sidePoints {
        if let foundPoint = sidePoints.points.firstIndex(where: { $0.name == point.ptname }) {
            sidePoints.points[foundPoint].position = CGPoint(x: point.ptlocation.x, y: point.ptlocation.y)
        }
    }
    
    for point in item.frontPoints {
        if let foundPoint = frontPoints.points.firstIndex(where: { $0.name == point.ptname }) {
            frontPoints.points[foundPoint].position = CGPoint(x: point.ptlocation.x, y: point.ptlocation.y)
        }
    }
}

func savePoints() {
    savePointsToModel(from: frontPoints, to: &item.frontPoints)
    savePointsToModel(from: sidePoints, to: &item.sidePoints)
}

private func savePointsToModel(from pointList: PointList, to modelPoints: inout [PosturePoint]) {
    for point in pointList.points {
        let loc = location(x: point.position.x, y: point.position.y)
        if let foundIndex = modelPoints.firstIndex(where: { $0.ptname == point.name }) {
            modelPoints[foundIndex].ptlocation = loc
        } else {
            let newPoint = PosturePoint(ptname: point.name, ptlocation: loc)
            modelPoints.append(newPoint)
        }
    }
}


var body: some View {
    VStack(spacing: 16) {
        Text("Posture Analysis")
            .font(.title)
            .bold()
        
        NavigationLink("Analysis View") {
            let height: CGFloat = globalData.nameRec?.height ?? 0
            LazyView(    AnalysisView(
                PAItem: item,
                frontPoints: frontPoints,
                sidePoints: sidePoints,
                height: height
            ))
        }
        .buttonStyle(.borderedProminent)
        
        Form {
            DatePicker(
                "Date:",
                selection: $item.date,
                displayedComponents: .date
            )
        }
        .frame(height: 60)
        .padding(.horizontal)
        
        HStack(spacing: 20) {
            ImageView(
                thePicture: $item.frontImage,
                thisView: "Front",
                thePoints: frontPoints
            )
            
            ImageView(
                thePicture: $item.sideImage,
                thisView: "Side",
                thePoints: sidePoints
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .padding()
    .onDisappear {
        savePoints()
    }
    .navigationTitle("Posture Edit")
}
}

#Preview {
//PostureView()
}

