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
    var body: some View {
        VStack {
            PostureMark(whichPostureView: whichPostureView,
                        dragAllowed:  .yonly ,
                        initalSpot: CGPoint(x: 0, y: 0))
        }
    }
}

struct PostureMark: View {
    @State var whichPostureView: String
    @State var dragAllowed: dragDirection
    @State var initalSpot: CGPoint  = CGPoint(x: 0, y: 0)
    @State  var dragAmount = CGSize.zero
    @State private var location = CGPoint(x: 0, y: 0)
    // Initial position of the image
    
    let iSize: CGFloat = 20.0
    let imgName = "GrabPt"
    
    init(whichPostureView: String,
         dragAllowed: dragDirection,
         initalSpot: CGPoint) {
        
        _whichPostureView = State(initialValue: whichPostureView)
        _dragAllowed = State(initialValue: dragAllowed)
        _initalSpot = State(initialValue: initalSpot)
         _location = State(initialValue: initalSpot)
        
    }
    
    var body: some View {
      GeometryReader { geo in
        // VStack {
            
        
             let containerWidth: CGFloat =   geo.size.width
            let containerHeight: CGFloat =    geo.size.height
            
            // Calculate boundaries for the graphic's center
          let  minX: CGFloat =  0
          let   maxX = containerWidth - iSize / 2
          let     minY: CGFloat = 0
          let     maxY = (containerHeight - iSize) / 2
            
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

