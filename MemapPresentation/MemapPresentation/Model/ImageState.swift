//
//  ImageState.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 12/05/2026.
//

import UIKit

@frozen
public enum ImageState {
    case empty
    case loading
    case success([UIImage])
    case failure(Error)
}
