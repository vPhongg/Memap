//
//  MapItemType.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 19/04/2026.
//


public enum MapItemType: String {
    
    // Default groups
    case workStudy = "workStudy"
    case tourism = "tourism"
    case food = "food"
    case drink = "drink"
    case entertainment = "entertainment"
    case bankATM = "bankATM"
    case store = "store"
    
    // Custom groups
    case favorite = "favorite"
    case others = "others"
    case unknown = "unknown"
    case explore = "explore"
    case random = "random"
    case hidden = "hidden"
    case quickshot = "quickshot" // Represents places that saves from QuickShot feature
    
    public init(rawValue: String?) {
        guard let rawValue, let value = MapItemType(rawValue: rawValue) else {
            self = .unknown
            return
        }
        
        self = value
    }
}
