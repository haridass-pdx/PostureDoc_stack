//
//  Item.swift
//  PostureDoc_sw
//
//  Created by Hari Dass Khalsa on 2/20/26.
//

import Foundation
import SwiftData

@Model
final class Item{
    var id: UUID = UUID()
    var name: String = ""
    @Attribute(.externalStorage) var sideImage: Data?
    @Attribute(.externalStorage) var frontImage: Data?
    
    init(theName: String) {
        name = theName
       // self.timestamp = timestamp
    }
}
