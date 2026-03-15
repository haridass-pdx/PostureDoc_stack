//
//  AnalysisView.swift
//  PostureDoc_stack
//
//  Created by Hari Dass Khalsa on 3/13/26.
//
enum shiftStr: String, CaseIterable {
    case leftSide = "left"
    case rightSide = "right"
    case anterior = "anterior"
    case posterior = "posterior"
    case none = "none"
}
struct itemData {
    var name: String = ""
    var shift: shiftStr = .none
    var amount: CGFloat = .zero
 
    
    mutating func zero(){
        self.name = ""
        self.shift = .none
        self.amount = .zero
        
    }
    
}

class analysisData{
     
   var inchPerPixel: CGFloat = .zero
    
    var sHeadPos: itemData?
    var sShoulderPos: itemData?
    var sHipPos: itemData?
    var sKneePos: itemData?
    var sAnklePos: itemData?
    var fHeadPos: itemData?
    var fHeartPos: itemData?
    var fNavelPos: itemData?
    var fFeetPos: itemData?
    var rtShoulderPos: itemData?
    var ltShoulderPos: itemData?
    var rtHipPos: itemData?
    var ltHipPos: itemData?
}

import SwiftUI
let scaleAmt = 0.5

struct AnalysisView: View {
    @Binding  var PAItem: PostureAnalysis
    @EnvironmentObject  var globalData: globalDataRec
    @State var AnalysisText: String = "-blank-"
    @State var nameRec:   Item?
    var height: CGFloat
    var frontPoints: PointList = PointList()
    var sidePoints: PointList = PointList()
    
    @State   var analysis: analysisData = analysisData()
    
    
    init(PAItem: Binding<PostureAnalysis>,
         frontPoints: PointList,
         sidePoints: PointList,
            height: CGFloat) {
        _PAItem = PAItem
        self.frontPoints = frontPoints
        self.sidePoints = sidePoints
        self.height = height
        
        
        calcPosture()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack{
                Text("Posture Analysis")
                    .font(Font.largeTitle)
                Spacer()
            }
            HStack{
                
                Text("Date: ") + Text("\(PAItem.date,  format: .dateTime.day().month().year())")
            }
            let name = globalData.nameRec?.fullName() ?? ""
            Text("Name: \(name)")
            VStack{
                HStack {
                    ShowView(
                        thePicture: $PAItem.frontImage,
                        thisView: "Front",
                        thePoints: frontPoints  )
                    .scaleEffect(scaleAmt)
                    ShowView(thePicture: $PAItem.sideImage,
                             thisView: "Side",
                             thePoints: sidePoints)
                    .scaleEffect(scaleAmt)
                    
                }
                .position(x: 300, y: 125)
                
                Text(AnalysisText)
                    .position(x: 25, y: -90)
                
            }
            
            Spacer()
        }
        .padding(.leading, 50)
        .navigationTitle("Back to Edit")
        .task{
            calcPosture()
        }
    }
    
    func calcPosture(){
        
        var top_y: CGFloat = 0
        var bottom_y: CGFloat = 00.0
        //var aHeight: Double = 0
      //      nameRec = globalData.nameRec
        for point in frontPoints.points {
             setFValues(point: point, top_y: &top_y, bottom_y: &bottom_y)
         }
         
      
        
        analysis.inchPerPixel = height / (bottom_y - top_y)
        
        for point in sidePoints.points {
            setSValues(point: point)
        }
    }
    

    
    func setSValues(point:  ThePoint){
        
        switch (point.name){
        case  "Head-Side":
            analysis.sHeadPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x)
            break
        case  "Shoulder":
            analysis.sShoulderPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x)
            break
        case "Hip":
            analysis.sHipPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x)
            break
        case  "Knee":
            analysis.sKneePos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x)
            break
        case  "Ankle":
            analysis.sAnklePos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x)
            break
        default:
            break

        }
        
    }
    
    /*
     var sHeadPos: itemData?
     var sShoulderPos: itemData?
     var sHipPos: itemData?
     var sKneePos: itemData?
     var sAnklePos: itemData?
     var fHeadPos: itemData?
     var fHeartPos: itemData?
     var fNavelPos: itemData?
     var fFeetPos: itemData?
     var rtShoulderPos: itemData?
     var ltShoulderPos: itemData?
     var rtHipPos: itemData?
     var ltHipPos: itemData?
     */
    
    func setFValues(point:  ThePoint, top_y: inout CGFloat, bottom_y: inout CGFloat){
        let zeroPoint:CGPoint =  CGPoint(x: 300 / 2, y: 0)
      
        switch(point.name){
        case "Head":
            analysis.fHeadPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x)
            break
        case "Heart":
            analysis.fHeartPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x)

            break
        case "Navel":
            analysis.fNavelPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x)

            break
        case  "Feet":
            analysis.fFeetPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x)

            break
        case  "Rt Shoulder":
            analysis.rtShoulderPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.y)

            break
        case   "Lt Shoulder":
            analysis.ltShoulderPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.y)

            break
        case  "Rt Hip":
            analysis.rtHipPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.y)

            break
        case  "Lt Hip":
            analysis.ltHipPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.y)

            break
        case  "TopMark":
            top_y = point.position.y
            break
        case "BottomMark":
            bottom_y = point.position.y
            break
        default:
            break
            
        }

    }
    
}
   

#Preview {
    // AnalysisView()
}

