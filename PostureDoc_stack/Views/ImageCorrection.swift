//
//  ImageCorrection.swift
//  PostureDoc_stack
//
//  Created by Hari Dass Khalsa on 3/15/26.
//

import Foundation
import AppKit
import PhotosUI


extension NSImage {
    func toSDR() -> NSImage {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return self
        }

        // Create a plain sRGB context — no HDR headroom
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: nil,
            width: cgImage.width,
            height: cgImage.height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return self }

        context.draw(cgImage, in: CGRect(x: 0, y: 0,
            width: cgImage.width,
            height: cgImage.height))

        guard let flatCGImage = context.makeImage() else { return self }
        return NSImage(cgImage: flatCGImage,
            size: NSSize(width: cgImage.width, height: cgImage.height))
    }
}

extension Data {
    /// Strips HDR metadata from image data and returns SDR-only JPEG data
    func strippingHDRMetadata() -> Data? {
        guard let nsImage = NSImage(data: self) else { return nil }
        
        // Convert to SDR using the existing method
        let sdrImage = nsImage.toSDR()
        
        // Convert to JPEG data without HDR metadata
        guard let tiffData = sdrImage.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData) else {
            return nil
        }
        
        // Create JPEG with compression quality 0.9 (adjust as needed)
        // This creates clean JPEG data without any HDR gain maps
        return bitmapRep.representation(using: .jpeg, properties: [.compressionFactor: 0.9])
    }
}




