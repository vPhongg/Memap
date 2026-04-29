//
//  Constant.swift
//  MemapPresentation
//
//  Created by Vu Dinh Phong on 06/03/2026.
//

import Foundation

struct Constant {
    static let memapLocalizationTableName: String = "Memap"
    
    static let addPlace = "ADD_PLACE"
    static let removePlace = "REMOVE_PLACE"
    static let unknownPlace = "UNKNOWN_PLACE"
    
    struct PlaceType {
        static let workStudy = "workStudy"
        static let tourism = "tourism"
        static let food = "food"
        static let drink = "drink"
        static let entertainment = "entertainment"
        static let bankATM = "bankATM"
        static let store = "store"
        static let favorite = "favorite"
        static let others = "others"
        static let unknown = "unknown"
        static let explore = "explore"
        static let random = "random"
        static let hidden = "hidden"
        static let quickshot = "quickshot"
    }
}

