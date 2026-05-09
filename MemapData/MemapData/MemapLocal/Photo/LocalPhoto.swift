//
//  LocalPhoto.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 06/04/2026.
//

import Foundation

public struct LocalPhoto {
    public let id: String
    public let jpegData: Data
    
    public init(name: String, jpegData: Data) {
        self.id = name
        self.jpegData = jpegData
    }
}
