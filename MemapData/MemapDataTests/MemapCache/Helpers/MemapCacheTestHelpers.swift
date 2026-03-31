//
//  MemapCacheTestHelpers.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 26/02/2026.
//


import Foundation
import MemapData
 
func uniquePlace() -> PlaceInfo {
    PlaceInfo(
        id: UUID(),
        name: nil,
        latitude: 1,
        longitude: 2,
        imagesPath: nil,
        isAdded: true
    )
}

func uniquePlaces() -> (models: [PlaceInfo], locals: [LocalPlaceInfo]) {
    let places = [uniquePlace(), uniquePlace(), uniquePlace()]
    let localItems = places.map {
        $0.toLocal()
    }
    
    return (models: places, locals: localItems)
}

// MARK: Cache-policy specific DSL methods
extension Date {
    private var cacheMaxAgeInDays: Int {
        return 7
    }
    
    private func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func minusCacheMaxAge() -> Date {
        adding(days: -cacheMaxAgeInDays)
    }
}

// MARK: Reusable DSL helper methods
extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
