//
//  Photo.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 08/05/2026.
//


import Foundation

public struct Photo {
    public let id: String
    public let jpegData: Data
    
    public init(name: String, jpegData: Data) {
        self.id = name
        self.jpegData = jpegData
    }
}
