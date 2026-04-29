//
//  PlaceTypePresentationModel.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 19/04/2026.
//

import MemapData

public enum PlaceTypePresentationModel: String, CaseIterable {
    // Default groups
    case workStudy = "workStudy"
    case tourism = "tourism"
    case food = "food"
    case drink = "drink"
    case entertainment = "entertainment"
    case bankATM = "bankATM"
    case store = "store"
    
    // Custom groups
    case favorite = "Favorite"
    case others = "others"
    case unknown = "unknown"
    case explore = "explore"
    case random = "random"
    case hidden = "hidden"
    case quickshot = "quickshot" // Represents places that saves from QuickShot feature
    
    var title: String {
        switch self {
        case .workStudy:
            Constant.PlaceType.workStudy
        case .tourism:
            Constant.PlaceType.tourism
        case .food:
            Constant.PlaceType.food
        case .drink:
            Constant.PlaceType.drink
        case .entertainment:
            Constant.PlaceType.entertainment
        case .bankATM:
            Constant.PlaceType.bankATM
        case .store:
            Constant.PlaceType.store
        case .favorite:
            Constant.PlaceType.favorite
        case .others:
            Constant.PlaceType.others
        case .unknown:
            Constant.PlaceType.unknown
        case .explore:
            Constant.PlaceType.explore
        case .random:
            Constant.PlaceType.random
        case .hidden:
            Constant.PlaceType.hidden
        case .quickshot:
            Constant.PlaceType.quickshot
        }
    }
}
