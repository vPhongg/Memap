//
//  RemoteFeedItem.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 16/04/2026.
//

import Foundation

struct RemotePlaceResponse: Decodable, Equatable {
    let id: String
    let name: String?
    let latitude: Double
    let longitude: Double
    let savedTimestamp: String?
    let imagesPath: String?
    let videosPath: String?
    let note: String?
    let backgroundColor: String?
    let type: String?
}
