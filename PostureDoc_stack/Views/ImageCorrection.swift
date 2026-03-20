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




