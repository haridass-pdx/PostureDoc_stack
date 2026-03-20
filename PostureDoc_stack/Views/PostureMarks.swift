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
let imgName = "GrabPt"
let iSize: CGFloat = 15.0


struct PostureMarks: View{
    @State var whichPostureView: String
    @State var thePoints: PointList
    @State var location: CGPoint = .zero
//    @State var topMark: ThePoint = ThePoint(name: topMarkName, position: CGPoint(x: 0, y: 0),
//                                            containRect: CGRect(x: 0, y: 0, width: 0, height: 225), dragAllowed: .yonly)
//    @State var bottomMark: ThePoint = ThePoint(name: bottomMarkName, position: CGPoint(x: 0, y: 450),
//                                               containRect: CGRect(x: 0, y: 225, width: 0, height: 225), dragAllowed: .yonly)

    var body: some View {
        GeometryReader { geo in
            let containerWidth: CGFloat =   geo.size.width
            let containerHeight: CGFloat =    geo.size.height
            VStack {
                ZStack{
                    Canvas { context, size in
                        var path = Path()
                        // Move to the first point
                                                    // Add lines to all subsequent points
                            for point in thePoints.points {
                                path.move(to: point.position)
                                if let nextPoint = point.nextPoint {
                                    path.addLine(to: nextPoint.position)
                                }
                                if point.dragAllowed == .yonly {
                                    let nextPoint = CGPoint(x: containerWidth, y: point.position.y)
                                    path.addLine(to: nextPoint)
                                }

                            }
                        
                        // Stroke the path
                        context.stroke(path, with: .color(.blue), lineWidth: 3)
                    }

                    middleLine()
//                    PostureMark(
//                        whichPostureView: whichPostureView,
//                        posturePoint: topMark)
//                    PostureMark(
//                        whichPostureView: whichPostureView,
//                        posturePoint: bottomMark
//                    )
                    ForEach($thePoints.points) { $thisPoint in
                      // Removed copyLocation call as per instructions
                       Image(imgName)
                           .resizable()
                           .scaledToFit()
                           .frame(width: iSize, height: iSize)
                           .padding(-2) // Creates the inset space
                           .background(Color.gray)
                           .clipShape(Circle())
                           .position(x: thisPoint.position.x, y: thisPoint.position.y)

                      .gesture(
                          DragGesture()
                              .onChanged { gesture in
                                  let newX = gesture.location.x
                                  let newY = gesture.location.y
                                  let minX: CGFloat = thisPoint.containRect.minX
                                  let maxX: CGFloat = thisPoint.containRect.maxX
                                  let minY: CGFloat = thisPoint.containRect.minY
                                  let maxY: CGFloat = thisPoint.containRect.maxY

                                  let limitedX = max(minX, min(newX, maxX))
                                  let limitedY = max(minY, min(newY, maxY))

                                  self.location = thisPoint.position
                                  switch thisPoint.dragAllowed {
                                  case .yonly:
                                      self.location = CGPoint(x: thisPoint.position.x, y: limitedY)
                                  case .xonly:
                                      self.location = CGPoint(x: limitedX, y: thisPoint.position.y)
                                  case .both:
                                      self.location = CGPoint(x: limitedX, y: limitedY)
                                  }
                                  thisPoint.position = self.location
                                  print("\(thisPoint.position)")

                              }
                              .onEnded { gesture in

                               //   dragAmount = .zero
                              }
                      )

                  }
                }
            }
        }
        .onDisappear {
            print(whichPostureView)
          //  print(topMark.description)
          //  print(bottomMark.description)
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

struct PostureMark2: View {
    @State var whichPostureView: String
    @State var posturePoint: ThePoint
    @State  var dragAmount = CGSize.zero
    @State var location: CGPoint = .zero
 //  @State   var endPoint: CGPoint = .zero
 //   @State  var startPoint: CGPoint =  .zero

    // Initial position of the image
    
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
          

              Image(imgName)
                  .resizable()
                  .scaledToFit()
                  .frame(width: iSize, height: iSize)
                  .padding(-2) // Creates the inset space
                  .background(Color.gray)
                  .clipShape(Circle())
                  .position(x: location.x, y: location.y)
              
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
struct PostureMark: View {
    @State var whichPostureView: String
    @State var posturePoint: ThePoint
    @State  var dragAmount = CGSize.zero
    @State var location: CGPoint = .zero
 //  @State   var endPoint: CGPoint = .zero
 //   @State  var startPoint: CGPoint =  .zero

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
              var lineColor: Color = .blue
              var lineWidth: CGFloat = 2.0
              var endPoint: CGPoint = location
              var startPoint: CGPoint = location


              Image(imgName)
                  .resizable()
                  .scaledToFit()
                  .frame(width: iSize, height: iSize)
                  .padding(-2) // Creates the inset space
                  .background(Color.gray)
                  .clipShape(Circle())
                  .position(x: location.x, y: location.y)
              
              Path { path in
                  // path.move(to: location)
                  
                  switch posturePoint.dragAllowed{
                  case .yonly:
                      startPoint = location
                     endPoint = CGPoint(x: containerWidth, y: location.y)
                      lineColor = .blue
                      lineWidth = 2
                      break
                  case .xonly:
                     endPoint = CGPoint(x: location.x, y: containerHeight)
                      break
                  case .both:
                      endPoint = location
                      if(posturePoint.nextPoint != nil){
                          startPoint = posturePoint.position
                          endPoint = posturePoint.nextPoint!.position
                          lineColor = .green
                          lineWidth = 1
                      }
                      break
                  }
                  print("endPoint: \(endPoint)")
             
                 path.move(to: startPoint)
                 path.addLine(to: endPoint)
              }
              // Apply stroke properties
              .stroke(lineColor, lineWidth: lineWidth)
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

