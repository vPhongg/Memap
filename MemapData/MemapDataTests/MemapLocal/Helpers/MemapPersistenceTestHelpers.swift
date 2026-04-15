//
//  MemapPersistenceTestHelpers.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 26/02/2026.
//


import Foundation
import MemapData
 
func uniquePlace() -> PlaceInfo {
    PlaceInfo(
        id: UUID().uuidString,
        name: nil,
        latitude: 1,
        longitude: 2,
        savedTimestamp: Date(),
        imagesPath: nil,
        videosPath: nil,
        note: nil,
        isSaved: true,
        backgroundColor: nil
    )
}

func uniquePlaces() -> (models: [PlaceInfo], locals: [LocalPlaceInfo]) {
    let places = [uniquePlace(), uniquePlace(), uniquePlace()]
    let localItems = places.map {
        $0.toLocal()
    }
    
    return (models: places, locals: localItems)
}
