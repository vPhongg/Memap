//
//  CachePolicy.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 26/02/2026.
//


import Foundation

final class CachePolicy {
    private init() {}
    
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date?, against date: Date) -> Bool {
        guard let timestamp,
              let maxAgeCache = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxAgeCache
    }
}
