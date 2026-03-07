//
//  PointClass.swift
//  PostureDoc_stack
//
//  Created by Hari Dass Khalsa on 3/6/26.
//

import Foundation
import SwiftUI


class ThePoint {
    var name: String = ""
    var position: CGPoint
    var containRect: CGRect = .zero
    var dragAllowed: dragDirection
    
    init(name: String,
        position: CGPoint, containRect: CGRect,
            dragAllowed: dragDirection) {
        self.name = name
        self.position = position
        self.containRect.origin.x = containRect.minX
        self.containRect.origin.y = containRect.minY
        self.containRect.size.width = containRect.width
        self.containRect.size.height = containRect.height
        self.dragAllowed = dragAllowed
    }
    var description: String {
        return "\(name) at \(position)"
    }
}
