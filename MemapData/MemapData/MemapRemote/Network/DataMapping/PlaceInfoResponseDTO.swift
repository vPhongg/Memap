//
//  LocalPlaceInfo.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 12/03/2026.
//

import Foundation
import MemapDomain

/// Naming as `PlaceInfoResponseDTO` just to have a good idea of following DTO design.
/// This is equivalent to naming `RemotePlaceInfo`
/// Use as data that being decode from json response.
public struct PlaceInfoResponseDTO: Decodable, Equatable {
    public let id: String?
    public let name: String?
    public let latitude: Double?
    public let longitude: Double?
    public let savedTimestamp: String?
    public let imagesPath: String?
    public let videosPath: String?
    public let note: String?
}

public extension PlaceInfoResponseDTO {
    func toModel() -> PlaceInfoDomain? {
        guard let id, let uuid = UUID(uuidString: id), let savedTimestamp else {
            return nil
        }
        return PlaceInfoDomain(
            id: uuid,
            name: name,
            latitude: latitude,
            longitude: longitude,
            savedTimestamp: convertToDate(from: savedTimestamp),
            imagesPath: imagesPath,
            videosPath: videosPath,
            note: note,
            isAdded: true // Fix true because `LocalPlaceInfo` represent items from `Persistence Storage`, which means it surely saved to `Persistence Storage` previously.
        )
    }
    
    private func convertToDate(from date: String) -> Date {
        let dateString: String? = "2026-03-11T01:20:00Z"

        let formatter = ISO8601DateFormatter()

        if let dateString,
           let date = formatter.date(from: dateString) {
            return date
        }
        
        return Date()
    }
}

extension Array where Element == PlaceInfoResponseDTO {
    func toModels() -> [PlaceInfoDomain] {
        return compactMap { $0.toModel() }
    }
}
