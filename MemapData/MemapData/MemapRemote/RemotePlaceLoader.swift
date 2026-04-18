//
//  RemotePlaceLoader.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 16/04/2026.
//

import Foundation

public final class RemotePlaceLoader {
    
    public enum Error: Swift.Error {
        case conectivity
        case invalidData
        case invalidStatusCodeNot200
    }
    
    public enum FetchMode {
        case withCheckedContinuation
        case asyncAwait
    }
    let mode: FetchMode
    
    let url: URL
    let client: HTTPClient
    
    public init(
        url: URL,
        client: HTTPClient,
        mode: FetchMode
    ) {
        self.url = url
        self.client = client
        self.mode = mode
    }
    
}

extension RemotePlaceLoader: PlaceLoader {
    public func load() async throws -> [Place] {
        
        switch mode {
        case .withCheckedContinuation:
            typealias LoadContinuation = CheckedContinuation<[Place], Swift.Error>
            return try await withCheckedThrowingContinuation { (continuation: LoadContinuation) in
                client.get(from: url) { result in
                    switch result {
                    case .success((let data, let httpResponse)):
                        do {
                            let places = try RemotePlaceLoader.map(data, from: httpResponse)
                            continuation.resume(returning: places)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                        
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            
        case .asyncAwait:
            let (data, response) = try await client.get(from: url)
            return try RemotePlaceLoader.map(data, from: response)
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Place] {
        do {
            let places = try PlacesMapper.map(data, from: response)
            return places.toModels()
        } catch {
            throw RemotePlaceLoader.Error.invalidData
        }
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

extension Array where Element == RemotePlaceResponse {
    func toModels() -> [Place] {
        return map {
            return Place(
                id: $0.id,
                name: $0.name,
                latitude: $0.latitude,
                longitude: $0.longitude,
                savedTimestamp: $0.savedTimestamp.toDate() ?? Date(),
                imagesPath: $0.imagesPath,
                videosPath: $0.videosPath,
                note: $0.note,
                isSaved: true, // `Place` is confirmed saved since it is loaded from remote.
                backgroundColor: $0.backgroundColor,
            )
        }
    }
}
