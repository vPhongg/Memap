//
//  Optional+Extensions.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 04/03/2026.
//

import Foundation

extension Optional where Wrapped == String {
    public var defaultUnknown: String {
        self ?? Constant.unknownPlace
    }
}
