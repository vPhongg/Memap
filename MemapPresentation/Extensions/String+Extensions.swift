//
//  String+Extentions.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 04/03/2026.
//

import Foundation

extension String {
    public static let empty = ""
    
    var localized: String {
        NSLocalizedString(
            self,
            tableName: Constant.memapLocalizationTableName,
            bundle: Bundle(identifier: Bundle.identifier)!,
            comment: .empty
        )
    }
}
