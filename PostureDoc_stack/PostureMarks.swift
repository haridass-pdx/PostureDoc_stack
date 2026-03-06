//
//  PostureMarks.swift
//  PostureDoc_sw
//
//  Created by Hari Dass Khalsa on 2/22/26.
//

import SwiftUI


enum dragDirection {
    case xonly
    case yonly
    case both
}

let dragInf = CGFloat.infinity


struct PostureMarks: View{
    @State var whichPostureView: String
    @State var topMark: CGPoint = CGPoint(x: 0, y: 0)
    @State var bottomMark: CGPoint = CGPoint(x: 0, y: 0)
    var body: some View {
        GeometryReader { geo in
            let containerWidth: CGFloat =   geo.size.width
            let containerHeight: CGFloat =    geo.size.height
            VStack {
                ZStack{
                    middleLine()
                    PostureMark(
                        whichPostureView: whichPostureView,
                        dragAllowed: .yonly,
                        initalSpot: CGPoint(x: 0, y: 0),
                        minVal: 0,
                        maxVal: containerHeight / 2,
                        theValue: $topMark
                    )
                    PostureMark(
                        whichPostureView: whichPostureView,
                        dragAllowed: .yonly,
                        initalSpot: CGPoint(x: 0, y: containerHeight),
                        minVal: containerHeight / 2,
                        maxVal: containerHeight,
                        theValue: $bottomMark
                    )
                }
            }
        }
    }
}

struct middleLine:  View {
    var body: some View {
        GeometryReader { geo in
            
            let containerWidth: CGFloat =   geo.size.width
            let containerHeight: CGFloat =    geo.size.height
            let startPoint = CGPoint(x: containerWidth / 2, y: 0)
            let endPoint = CGPoint(x: containerWidth / 2, y: containerHeight)
// Text("Hello, World!")
            Path { path in
                            // Move to the starting point
                            path.move(to: startPoint)
                            // Draw a line to the ending point
                            path.addLine(to: endPoint)
                        }
                        // Apply stroke properties
                        .stroke(Color.red, lineWidth: 1)
        }
    }
}

struct PostureMark: View {
    @State var whichPostureView: String
    @State var dragAllowed: dragDirection
    @State var minVal: Double
    @State var maxVal: Double
    @State var initalSpot: CGPoint  = CGPoint(x: 0, y: 0)
    @State  var dragAmount = CGSize.zero
    @State private var location = CGPoint(x: 0, y: 0)
    @Binding  var theValue: CGPoint
    // Initial position of the image
    
    let iSize: CGFloat = 20.0
    let imgName = "GrabPt"
    
    init(whichPostureView: String,
         dragAllowed: dragDirection,
         initalSpot: CGPoint,
         minVal: Double,
         maxVal: Double,
         theValue: Binding<CGPoint>) {
        
        _whichPostureView = State(initialValue: whichPostureView)
        _dragAllowed = State(initialValue: dragAllowed)
        _initalSpot = State(initialValue: initalSpot)
         _location = State(initialValue: initalSpot)
        _minVal = State(initialValue: minVal)
        _maxVal = State(initialValue: maxVal)
        _theValue = theValue
    }
    
    var body: some View {
      GeometryReader { geo in
        // VStack {
            
        
             let containerWidth: CGFloat =   geo.size.width
            let containerHeight: CGFloat =    geo.size.height
            
            // Calculate boundaries for the graphic's center
          let  minX: CGFloat =  0
          let  maxX: CGFloat = containerWidth - iSize / 2
          let     minY: CGFloat =  CGFloat(minVal)
          let     maxY: CGFloat = CGFloat(maxVal)
            
            Image(imgName)
                .resizable()
                .scaledToFit()
                .frame(width: iSize, height: iSize)
                .padding(-2) // Creates the inset space
                .background(Color.gray)
                .clipShape(Circle())
                .position(x: location.x, y: location.y)
          

                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            
                            
                            let newX = gesture.location.x
                            let newY = gesture.location.y
                            
                            // Clamp the new position within the container bounds
                            let limitedX = max(minX, min(newX, maxX))
                            let limitedY = max(minY, min(newY, maxY))
                            
                           // self.location = CGPoint(x: limitedX, y: limitedY)
                            
                          switch(dragAllowed){
                            case .yonly:
                                
                              self.location.y =  limitedY ///CGPoint(x: limitedX, y: limitedY)
                                break
                            case .xonly:
                              self.location.x  =  limitedX
                              
                              break
                            case .both:
                               self.location = CGPoint(x: limitedX, y: limitedY)
                                break
                            }
                            theValue = self.location
                            print("\(theValue)")

                        }
                        .onEnded { gesture in

                            
                            dragAmount = .zero
                        }
                )
        }
        
        
        
    }
    
    
    func limitDrag(theSize: inout CGSize,
                   minX: CGFloat,
                   maxX:  CGFloat,
                   minY:  CGFloat,
                   maxY:  CGFloat ) {
        var theHeight = theSize.height
        var theWidth = theSize.width
                
        theHeight = max(min(maxY, theHeight), minY)
       // theHeight =
        
        theWidth = max(min(maxX, theWidth), minX)
       // theWidth =
        
        theSize.self = CGSize(width: theWidth, height: theHeight)
        
    }
    
}
#Preview {
    // PostureMarks()
}

