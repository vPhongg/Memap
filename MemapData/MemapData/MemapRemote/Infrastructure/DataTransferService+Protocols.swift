//
//  is.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 13/03/2026.
//


/// This class is used to convert DTO object to Domain object.
/// Logger for DataTransfer error can be implement here.
public protocol DataTransferService {
    typealias CompletionHandler = (Result<[PlaceInfoResponseDTO], Error>) -> Void
    
    @discardableResult
    func request(completion: @escaping CompletionHandler) -> NetworkCancellable?
}