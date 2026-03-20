//
//  Item.swift
//  PostureDoc_sw
//
//  Created by Hari Dass Khalsa on 2/20/26.
//

import Foundation
import SwiftData
import CoreGraphics
import ImageIO
import AppKit
import PhotosUI



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
    func fullName() -> String {
        "\(firstname) \(lastname)"
    }
}

@Model
final class PostureAnalysis: Identifiable {
    var date: Date = Date()
    var sideImage: ImageRec  = ImageRec(imagename: "Side Image" )
    var frontImage: ImageRec = ImageRec(imagename: "Front Image")
    var sidePoints: [PosturePoint] = []
    var frontPoints: [PosturePoint] = []
    @Attribute(.externalStorage)  var analysis: String = ""
    init(date: Date){
        self.date = date
        
    }
}

@Model
final class ImageRec {
    var imagename = ""
    @Attribute(.externalStorage)    var image: Data?
    var isSDR: Bool = false
    var scale: Double = 1.0
    var rotation: Double = 0
    var translation: location = location(x: 0, y: 0)
    
    init(imagename: String = ""){
        self.imagename  = imagename
            }
}


extension ImageRec {
    /// Loads imageData, converts to SDR, and resaves back to imageData
    func convertAndSaveSDR() {
        guard let data = image,
              let source = CGImageSourceCreateWithData(data as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(
                  source,
                  0,
                  [kCGImageSourceShouldAllowFloat: false] as CFDictionary
              )
        else { return }

        // Flatten to sRGB
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: nil,
            width: cgImage.width,
            height: cgImage.height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return }

        context.draw(cgImage, in: CGRect(
            x: 0, y: 0,
            width: cgImage.width,
            height: cgImage.height
        ))

        guard let flatCGImage = context.makeImage() else { return }

        // Convert back to Data (JPEG or PNG)
        let nsImage = NSImage(
            cgImage: flatCGImage,
            size: NSSize(width: cgImage.width, height: cgImage.height)
        )

        guard let tiffData = nsImage.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let newData = bitmap.representation(
                  using: .jpeg,
                  properties: [.compressionFactor: 0.9]
              )
        else { return }

        // Resave back into SwiftData
        image = newData
    }
}
struct location: Codable {
    var x: Double = 0.00
    var y: Double = 0.00
}

@Model
final class PosturePoint {
    var id: UUID = UUID()
    var ptname: String = ""
    var ptlocation: location = location(x: 0, y: 0)
   //  @Relationship(inverse: \Item.)

    var item: Item?
    init(ptname: String,
         ptlocation: location) {
        self.ptname = ptname
        self.ptlocation = ptlocation
    }
}
