//
//  PlacesMapper.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 16/04/2026.
//

import Foundation

struct PlacesMapper {
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemotePlaceResponse] {
        guard response.statusCodeIs200 else {
            throw RemotePlaceLoader.Error.invalidStatusCodeNot200
        }
        
        guard let places = try? JSONDecoder().decode([RemotePlaceResponse].self, from: data) else {
            throw RemotePlaceLoader.Error.invalidData
        }
        
        return places
    }
    
}
