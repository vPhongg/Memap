//
//  asd.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 16/04/2026.
//

import Foundation

extension Optional where Wrapped == String {
    func toDate() -> Date? {
        guard let self else { return nil }
        
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: self)
    }
}

