//
//  AnalysisView.swift
//  PostureDoc_stack
//
//  Created by Hari Dass Khalsa on 3/13/26.
//
internal import UniformTypeIdentifiers
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
import AppKit
import PDFKit

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
    var side_transform: CGAffineTransform
    var front_transform: CGAffineTransform
    @State   var analysis: analysisData = analysisData()
    @State private var showingShareSheet = false
    
    
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
        let sideImage = PAItem.sideImage
    
         side_transform = CGAffineTransform(scaleX: sideImage.scale, y: sideImage.scale)
            .rotated(by: sideImage.rotation) // Rotates by 45 degrees (radians)
            .translatedBy(x: 50.00 , //sideImage.translation.x,
                          y: 0.00 // sideImage.translation.y
                            ) // Translates by 50 points
        let frontImage = PAItem.frontImage
         front_transform = CGAffineTransform(scaleX: frontImage.scale, y: frontImage.scale)
            .rotated(by: frontImage.rotation) // Rotates by 45 degrees (radians)
            .translatedBy(x: 0.00, //frontImage.translation.x,
                          y:  0.00 //frontImage.translation.y
                            ) // Translates by 50 points

    }
    
    var body: some View {
                VStack(alignment: .leading, spacing: 10){
            HStack{
                Text("Posture Analysis")
                    .font(Font.largeTitle)
                Spacer()
                
                // Action buttons
                Button(action: printPDF) {
                    Label("Print", systemImage: "printer")
                }
                .help("Print this analysis")
                
                Button(action: emailPDF) {
                    Label("Email", systemImage: "envelope")
                }
                .help("Email this analysis as PDF")
                
                Button(action: savePDF) {
                    Label("Save PDF", systemImage: "arrow.down.doc")
                }
                .help("Save analysis as PDF")
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
                        .transformEffect(front_transform)
                        //.scaleEffect(scaleAmt)
                        ShowView(thePicture: PAItem.sideImage,
                                 thisView: "Side",
                                 thePoints: sidePoints)
                        .transformEffect(side_transform)
                       // .scaleEffect(scaleAmt)
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
    
    // MARK: - PDF Generation and Actions
    
    /// Creates a PDF document from the current view
    private func generatePDF() -> Data? {
        // Create a printable version of the view without the action buttons
        let printView = PrintableAnalysisView(
            PAItem: PAItem,
            frontPoints: frontPoints,
            sidePoints: sidePoints,
            height: height,
            shiftArray: shiftArray,
            AnalysisText: AnalysisText,
            globalData: globalData
        )
        
        let renderer = ImageRenderer(content: printView)
        
        // Set the scale for better quality
        renderer.scale = 2.0
        
        // Standard US Letter size in points (8.5" x 11")
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        
        renderer.proposedSize = ProposedViewSize(width: pageWidth, height: pageHeight)
        
        // Render to PDF
        let pdfData = NSMutableData()
        guard let consumer = CGDataConsumer(data: pdfData as CFMutableData),
              let pdfContext = CGContext(consumer: consumer, mediaBox: nil, nil) else {
            return nil
        }
        
        var mediaBox = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        pdfContext.beginPage(mediaBox: &mediaBox)
        renderer.render { size, renderer in
            renderer(pdfContext)
        }
        pdfContext.endPage()
        pdfContext.closePDF()
        
        return pdfData as Data
    }
    
    /// Prints the analysis report
    private func printPDF() {
        guard let pdfData = generatePDF() else {
            print("Failed to generate PDF")
            return
        }
        
        // Create a temporary file URL for the PDF
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("PostureAnalysis_\(UUID().uuidString).pdf")
        
        do {
            try pdfData.write(to: tempURL)
            
            // Open print dialog
            let printInfo = NSPrintInfo.shared
            printInfo.horizontalPagination = .fit
            printInfo.verticalPagination = .fit
            printInfo.isHorizontallyCentered = true
            printInfo.isVerticallyCentered = true
            
            if let pdfDoc = PDFDocument(url: tempURL) {
                let printOperation = pdfDoc.printOperation(for: printInfo, scalingMode: .pageScaleToFit, autoRotate: true)
                printOperation?.runModal(for: NSApp.keyWindow ?? NSWindow(), delegate: nil, didRun: nil, contextInfo: nil)
            }
            
            // Clean up temporary file
            try? FileManager.default.removeItem(at: tempURL)
        } catch {
            print("Error printing PDF: \(error)")
        }
    }
    
    /// Saves the PDF to a user-selected location
    private func savePDF() {
        guard let pdfData = generatePDF() else {
            print("Failed to generate PDF")
            return
        }
        
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.pdf]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        
        let name = globalData.nameRec?.fullName() ?? "Patient"
        let dateString = PAItem.date.formatted(date: .numeric, time: .omitted)
        savePanel.nameFieldStringValue = "PostureAnalysis_\(name)_\(dateString).pdf"
        
        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                do {
                    try pdfData.write(to: url)
                    print("PDF saved successfully to \(url)")
                } catch {
                    print("Error saving PDF: \(error)")
                }
            }
        }
    }
    
    /// Opens email client with PDF attached
    private func emailPDF() {
        guard let pdfData = generatePDF() else {
            print("Failed to generate PDF")
            return
        }
        
        // Create a temporary file URL for the PDF
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("PostureAnalysis.pdf")
        
        do {
            try pdfData.write(to: tempURL)
            
            // Create email with attachment using NSSharingService
            let sharingService = NSSharingService(named: .composeEmail)
            
            let name = globalData.nameRec?.fullName() ?? "Patient"
            let dateString = PAItem.date.formatted(date: .abbreviated, time: .omitted)
            
            sharingService?.subject = "Posture Analysis Report - \(name) - \(dateString)"
            
            if sharingService?.canPerform(withItems: [tempURL]) == true {
                sharingService?.perform(withItems: [tempURL])
            } else {
                // Fallback: open in workspace
                NSWorkspace.shared.open(tempURL)
            }
        } catch {
            print("Error emailing PDF: \(error)")
        }
    }
    
}

// MARK: - Printable Version of Analysis View

/// A version of AnalysisView optimized for printing/PDF export (without action buttons)
struct PrintableAnalysisView: View {
    var PAItem: PostureAnalysis
    var frontPoints: PointList
    var sidePoints: PointList
    var height: CGFloat
    var shiftArray: [shiftData]
    var AnalysisText: String
    var globalData: globalDataRec
    
    let leftEdge: CGFloat = 250
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GeometryReader{ proxy in
                // Header
                VStack{
                    HStack(alignment: .firstTextBaseline, spacing: 5){
                        Text("Posture Analysis Report for: ")
                            .font(.body)
                            .fontWeight(.bold)
                        Text(" \(globalData.nameRec?.fullName() ?? "N/A") ")
                        Spacer()
                        Text("Date: \(PAItem.date.formatted(date: .abbreviated, time: .omitted))")
                    }
                    Divider()
            }
              .frame(width: proxy.size.width  , height: 30)
              
                   // Images and Displacement Table
                HStack(alignment: .center, spacing: 20) {
                    // Images
                    HStack(spacing: 10) {
                        VStack {
                          /*  Text("Front View")
                                .font(.caption)
                                .fontWeight(.semibold)*/
                            ShowView(
                                thePicture: PAItem.frontImage,
                                thisView: "Front",
                                thePoints: frontPoints
                            )
                        }
                        
                        VStack {
                          /*  Text("Side View")
                                .font(.caption)
                                .fontWeight(.semibold)*/
                            ShowView(
                                thePicture: PAItem.sideImage,
                                thisView: "Side",
                                thePoints: sidePoints
                            )
                        }
                    }
                    .scaleEffect(0.4)
                    
                    // Displacement Table
                    VStack(alignment: .leading, spacing: 0) {
                        Text("  Postural Deviations")
                            .font(.subheadline)
                            .padding(.bottom, 5)
                        
                        // Custom table header
                        HStack(spacing: 0) {
                            Text("Area")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(width: 90, alignment: .leading)
                            Text("Direction")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(width: 75, alignment: .leading)
                            Text("Amount")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(width: 75, alignment: .leading)
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 6)
                        .background(Color.gray.opacity(0.2))
                        
                        Divider()
                        
                        // Table rows
                        VStack(spacing: 0) {
                            ForEach(shiftArray) { item in
                                HStack(spacing: 0) {
                                    Text(item.name)
                                        .font(.caption)
                                        .frame(width: 90, alignment: .leading)
                                    Text(item.direction.rawValue)
                                        .font(.caption)
                                        .frame(width: 75, alignment: .leading)
                                    Text(String(format: "%.2f in", abs(item.amount)))
                                        .font(.caption)
                                        .frame(width: 75, alignment: .leading)
                                }
                                .padding(.vertical, 3)
                                .padding(.horizontal, 6)
                                .background(shiftArray.firstIndex(where: { $0.id == item.id })! % 2 == 0 ? Color.clear : Color.gray.opacity(0.05))
                                
                                if item.id != shiftArray.last?.id {
                                    Divider()
                                }
                            }
                        }
                    }
                    .frame(width: 260)
                   
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .offset(x: -130, y: 0)
                }
                .position(x: leftEdge, y: 125)
                .padding(.vertical, 10)
                
             //   Divider()
                
                // Analysis Text
               
                                        
                VStack(alignment: .leading, spacing: 5) {
                    //Divider()

                    Text("Analysis Notes:")
                        .font(.subheadline)
                        .padding(.bottom, 5)
                
                //.position(x: leftEdge, y: 245)
                
                    Text(AnalysisText)
                        .font(.system(size: 10))
                        // .background(Color.gray.opacity(0.1))
                }  .frame(width: proxy.size.width * 0.90, height: 500, alignment: .leading)
                        .position(x: leftEdge, y: 460)
                        
               // Spacer()
                
                // Footer
                VStack(alignment: .center) {
                    Divider()
                    Text("Analysis Report from Khalsa Pain Relief Clinic, P.C. 503-238-1032")
                    
                    Text("Generated on \(Date().formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        //.frame(maxWidth: .infinity, alignment: .trailing)
                    
                }
                .frame(width: proxy.size.width * 0.95)
                .position(x: leftEdge, y: proxy.size.height)

            }
        }
        .padding(40)
        .frame(width: 612, height: 792) // US Letter size
    }
}
   

#Preview {
    // AnalysisView()
}

