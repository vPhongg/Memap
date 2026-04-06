//
//  Photo.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 06/04/2026.
//

import Foundation

public struct Photo {
    public let name: String
    public let jpegData: Data
    
    public init(name: String, jpegData: Data) {
        self.name = name
        self.jpegData = jpegData
    }
}
