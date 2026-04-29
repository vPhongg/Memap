//
//  PlaceTypePresentationModel.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 19/04/2026.
//

import MemapData

public enum PlaceTypePresentationModel: String {
    // Default groups
    case workStudy = "workStudy"
    case tourism = "tourism"
    case food = "food"
    case drink = "drink"
    case entertainment = "entertainment"
    case bankATM = "bankATM"
    case store = "store"
    
    // Custom groups
    case favorite
    case others = "others"
    case unknown = "unknown"
    case explore = "explore"
    case random = "random"
    case hidden = "hidden"
    case quickshot = "quickshot" // Represents places that saves from QuickShot feature
}
