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
    case high = "high"
    case low = "low"
    case none = "none"
}

enum shiftArea: String, CaseIterable {
    case head = "head"
    case shoulder = "shoulder"
    case hip = "hip"
    case knee = "knee"
    case ankle = "ankle"
    case headLat = "headLat"
    case heart = "heart"
    case navel = "navel"
    case highShoulder = "high shoulder"
    case highHip = "high hip"
}

struct shiftData: Identifiable{
    var id: UUID = UUID()
    var name: String = ""
    var direction: shiftStr = .none
    var amount: CGFloat = .zero
    var printStr: String = ""
}

struct itemData {
    var name: String = ""
    var shift: shiftStr = .none
    var amount: CGFloat = .zero
    var calcAmt: CGFloat = .zero
 
    
    mutating func zero(){
        self.name = ""
        self.shift = .none
        self.amount = .zero
        self.calcAmt = .zero
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
    
    func setCalcAmt(){
        doCalc(item: &sHeadPos)
        doCalc(item: &sShoulderPos)
        doCalc(item: &sHipPos)
        doCalc(item: &sKneePos)
        doCalc(item: &sAnklePos)
        
        doCalc(item: &fHeadPos)
        doCalc(item: &fHeartPos)

        doCalc(item: &rtShoulderPos)
        doCalc(item: &ltShoulderPos)
        doCalc(item: &rtHipPos)
        doCalc(item: &ltHipPos)
 
      
      }
    
    func doCalc(item: inout itemData?){
        guard let amount = item?.amount else { return }
        item?.calcAmt = amount * inchPerPixel
    }
}

import SwiftUI
let scaleAmt = 0.5

struct AnalysisView: View {
    @EnvironmentObject  var globalData: globalDataRec
    @State var AnalysisText: String
    @State var nameRec:   Item?
    var PAItem: PostureAnalysis
    @State var shiftArray: [shiftData]
    var height: CGFloat
    var frontPoints: PointList = PointList()
    var sidePoints: PointList = PointList()
    
    @State   var analysis: analysisData = analysisData()
    
    
    init(PAItem: PostureAnalysis,
         frontPoints: PointList,
         sidePoints: PointList,
            height: CGFloat,
            shiftArray: [shiftData],
         AnalysisText: String) {
        self.PAItem = PAItem
        self.frontPoints = frontPoints
        self.sidePoints = sidePoints
        self.height = height
        self.shiftArray = shiftArray
        self.AnalysisText = AnalysisText
        
      //  calcPosture()
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
                HStack{
                    HStack {
                        ShowView(
                            thePicture: PAItem.frontImage,
                            thisView: "Front",
                            thePoints: frontPoints  )
                        //.scaleEffect(scaleAmt)
                        ShowView(thePicture: PAItem.sideImage,
                                 thisView: "Side",
                                 thePoints: sidePoints)
                        //.scaleEffect(scaleAmt)
                    }
                    .scaleEffect(scaleAmt)
                    
                    DisplacementList
                        .offset(x: -80, y: 0)
                    
                }
                .frame(width: 300)
                .position(x: 300, y: 125)

                
                Text(AnalysisText)
                    .frame(width: 700, height: 450)
                   .position(x: 350, y: 160)
                
            }
            
            Spacer()
        }
        .padding(.leading, 50)
        .navigationTitle("Back to Edit")
    /*    .task{
            calcPosture()
        }*/
    }
    
    var DisplacementList: some View {
        
        
        
        Table(shiftArray) {
            TableColumn("Area", value: \.name)
                .width(90)
            TableColumn("Direction", value: \.direction.rawValue)
                .width(75)
            TableColumn("Amount") { item in
                Text(String(format: "%.2f", abs(item.amount))) + Text(" in")
            }
            .width(75)
        }
        .frame(width: 275, height: 175)
                        
        }
        
   

    
    
  /*  func calcPosture(){
        
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

    func generateText(){
        
    }
   */
    
    func setSValues(point:  ThePoint){
        
        switch (point.name){
        case  "Head-Side":
            analysis.sHeadPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x,
                                         calcAmt: 0.00)
            break
        case  "Shoulder":
            analysis.sShoulderPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x,
                                             calcAmt: 0.00)
            break
        case "Hip":
            analysis.sHipPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x,
                                        calcAmt: 0.00)
            break
        case  "Knee":
            analysis.sKneePos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x,
                                         calcAmt: 0.00)
            break
        case  "Ankle":
            analysis.sAnklePos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x,
                                          calcAmt: 0.00)
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
                                amount: point.position.x,
                                         calcAmt: 0.00)
            break
        case "Heart":
            analysis.fHeartPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x)

            break
        case "Navel":
            analysis.fNavelPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x,
                                          calcAmt: 0.00)

            break
        case  "Feet":
            analysis.fFeetPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.x,
                                         calcAmt: 0.00)

            break
        case  "Rt Shoulder":
            analysis.rtShoulderPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.y,
                                              calcAmt: 0.00)

            break
        case   "Lt Shoulder":
            analysis.ltShoulderPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.y,
                                              calcAmt: 0.00)

            break
        case  "Rt Hip":
            analysis.rtHipPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.y,
                                         calcAmt: 0.00)

            break
        case  "Lt Hip":
            analysis.ltHipPos = itemData(name: point.name,
                                    shift: .none,
                                amount: point.position.y,
                                         calcAmt: 0.00)

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

