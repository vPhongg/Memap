//
//  ImageState.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 12/05/2026.
//

import UIKit

public enum ImageStateError: Error {
    case loadImagesFailed
}

@frozen
public enum ImageState: Equatable {
    case empty
    case loading
    case success([UIImage])
    case failure(ImageStateError)
}
