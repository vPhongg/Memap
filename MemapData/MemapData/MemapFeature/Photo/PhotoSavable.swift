//
//  PhotoSavable.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 08/05/2026.
//

import Foundation

public protocol PhotoSavable {
    func save(_ photos: [Photo], toDirectory url: URL) async throws
}
