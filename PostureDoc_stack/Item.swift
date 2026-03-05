//
//  Item.swift
//  PostureDoc_sw
//
//  Created by Hari Dass Khalsa on 2/20/26.
//

import Foundation
import SwiftData
import CoreGraphics

@Model
final class Item{
    var id: UUID = UUID()
    var firstname: String = ""
    var lastname: String = ""
    var gender: String = "female"
    var height: Double =  0.00
    var postureAnalysis: [PostureAnalysis] = []
    init(theName: String) {
        firstname = theName
       // self.timestamp = timestamp
    }
}

@Model
final class PostureAnalysis: Identifiable {
    var date: Date = Date()
    var sideImage: ImageRec  = ImageRec(imagename: "Side Image" )
    var frontImage: ImageRec = ImageRec(imagename: "Front Image")
    @Attribute(.externalStorage)  var analysis: String = ""
    init(date: Date){
        self.date = date
        
    }
}

@Model
final class ImageRec {
    var imagename = ""
    @Attribute(.externalStorage)    var image: Data?
    var scale: Double = 1.0
    var rotation: Double = 0
    var translation: location = location(x: 0, y: 0)
    
    init(imagename: String = ""){
        self.imagename  = imagename
            }
}
struct location: Codable {
    var x: Double = 0.00
    var y: Double = 0.00
}

@Model
final class Points {
    var id: UUID = UUID()
    var ptname: String = ""
    var ptlocation: location = location(x: 0, y: 0)
    var next: Points?
   //  @Relationship(inverse: \Item.)

    var item: Item?
    init(ptname: String) {
        self.ptname = ptname
    }
}
