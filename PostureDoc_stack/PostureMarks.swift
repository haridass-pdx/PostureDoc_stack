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
    @State var topMark: ThePoint = ThePoint(name: "TopMark", position: CGPoint(x: 0, y: 0),
                                            containRect: CGRect(x: 0, y: 0, width: 0, height: 225), dragAllowed: .yonly)
    @State var bottomMark: ThePoint = ThePoint(name: "BottomMark", position: CGPoint(x: 0, y: 450),
                                               containRect: CGRect(x: 0, y: 225, width: 0, height: 225), dragAllowed: .yonly)

    var body: some View {
        GeometryReader { geo in
            let containerWidth: CGFloat =   geo.size.width
            let containerHeight: CGFloat =    geo.size.height
            VStack {
                ZStack{
                    middleLine()
                    PostureMark(
                        whichPostureView: whichPostureView,
                        posturePoint: topMark)
                    PostureMark(
                        whichPostureView: whichPostureView,
                        posturePoint: bottomMark
                    )
                }
            }
        }
        .onDisappear {
            print(whichPostureView)
            print(topMark.description)
            print(bottomMark.description)
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
    @State var posturePoint: ThePoint
    @State  var dragAmount = CGSize.zero
    @State var location: CGPoint = .zero
 
    // Initial position of the image
    
    let iSize: CGFloat = 15.0
    let imgName = "GrabPt"
    //@State var endPoint: CGPoint = .zero
    
    init(whichPostureView: String,
         posturePoint: ThePoint) {
        
        _whichPostureView = State(initialValue: whichPostureView)
        _posturePoint = State(initialValue: posturePoint)
        _location = State(initialValue: posturePoint.position)
    }
    
    var body: some View {
      GeometryReader { geo in
        // VStack {
            let containerWidth: CGFloat =   geo.size.width
            let containerHeight: CGFloat =    geo.size.height
            
            // Calculate boundaries for the graphic's center
          let  minX: CGFloat =  posturePoint.containRect.minX
          let  maxX: CGFloat = posturePoint.containRect.maxX
          let     minY: CGFloat =  posturePoint.containRect.minY
          let     maxY: CGFloat = posturePoint.containRect.maxY
          ZStack{
              Image(imgName)
                  .resizable()
                  .scaledToFit()
                  .frame(width: iSize, height: iSize)
                  .padding(-2) // Creates the inset space
                  .background(Color.gray)
                  .clipShape(Circle())
                  .position(x: location.x, y: location.y)
              Path { path in
                  var endPoint: CGPoint = .zero
                  path.move(to: location)
                  
                  switch posturePoint.dragAllowed{
                  case .yonly:
                     endPoint = CGPoint(x: containerWidth, y: location.y)
                      break
                  case .xonly:
                     endPoint = CGPoint(x: location.x, y: containerHeight)
                      break
                  case .both:
                      endPoint = location
                      break
                  }
                  print("endPoint: \(endPoint)")
                  path.addLine(to: endPoint)
              }
              // Apply stroke properties
              .stroke(Color.blue, lineWidth: 2)
          }
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            
                            
                            let newX = gesture.location.x
                            let newY = gesture.location.y
                            
                            // Clamp the new position within the container bounds
                            let limitedX = max(minX, min(newX, maxX))
                            let limitedY = max(minY, min(newY, maxY))
                            
                           // self.location = CGPoint(x: limitedX, y: limitedY)
                            
                            switch(posturePoint.dragAllowed){
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
                            posturePoint.position = self.location
                            print("\(posturePoint.position)")

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

