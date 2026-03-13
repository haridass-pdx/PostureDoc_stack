//
//  PointClass.swift
//  PostureDoc_stack
//
//  Created by Hari Dass Khalsa on 3/6/26.
//

import Foundation
import SwiftUI
import Observation

enum sidePtNames: String, CaseIterable {
    case headSide = "Head-Side"
    case shoulder = "Shoulder"
    case hip = "Hip"
    case knee = "Knee"
    case ankle = "Ankle"
}

enum frontPtNames: String, CaseIterable {
    case head = "Head"
    case heart = "Heart"
    case navel = "Navel"
    case feet = "Feet"
    case rtShoulder = "Rt Shoulder"
    case ltShoulder = "Lt Shoulder"
   case rtHip = "Rt Hip"
    case ltHip = "Lt Hip"
 }

let topMarkName = "TopMark"
let bottomMarkName = "BottomMark"

@Observable
class ThePoint: Identifiable {
    let id = UUID()
    var name: String = ""
    var position: CGPoint
    var containRect: CGRect = .zero
    var dragAllowed: dragDirection
    var nextPoint: ThePoint?
    
    init(name: String,
        position: CGPoint, containRect: CGRect,
            dragAllowed: dragDirection) {
        self.name = name
        self.position = position
        _containRect.origin.x = containRect.minX
        _containRect.origin.y = containRect.minY
        _containRect.size.width = containRect.width
        _containRect.size.height = containRect.height
        _dragAllowed = dragAllowed
    }
    var description: String {
        return "\(name) at \(position)"
    }
}

@Observable
class PointList{
    var points: [ThePoint] = []
    func append(_ newPoint: ThePoint){
        points.append(newPoint)
    }
}
