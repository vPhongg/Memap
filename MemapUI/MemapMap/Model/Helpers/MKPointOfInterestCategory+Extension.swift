//
//  MKPointOfInterestCategory+Extension.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 19/04/2026.
//

import MapKit

extension Optional where Wrapped == MKPointOfInterestCategory {
    
    func toMapItemType() -> MapItemType {
        guard let self else { return .unknown }
        
        switch self {
        case .library, .planetarium, .school, .university:
            return .workStudy
            
        case .movieTheater, .nightlife, .baseball, .basketball, .bowling, .goKart, .golf, .hiking, .miniGolf, .rockClimbing, .skatePark, .skating, .skiing, .soccer, .stadium, .tennis, .volleyball, .fishing, .kayaking, .surfing, .swimming:
            return .entertainment
            
        case .museum, .musicVenue, .theater, .castle, .fortress, .landmark, .nationalMonument, .amusementPark, .aquarium, .beach, .campground, .fairground, .marina, .nationalPark, .park, .rvPark, .zoo:
            return .tourism
            
        case .bakery, .foodMarket, .restaurant:
            return .food
            
        case .brewery, .cafe, .distillery, .winery:
            return .drink
            
        case .atm, .bank:
            return .bankATM
            
        case .store:
            return .store
            
        case .animalService, .automotiveRepair, .beauty, .evCharger, .fitnessCenter, .laundry, .mailbox, .postOffice, .restroom, .spa, .fireStation, .hospital, .pharmacy, .police, .airport, .carRental, .conventionCenter, .gasStation, .hotel, .parking, .publicTransport:
            return .others
            
            
        default:
            return .unknown
            
        }
    }
}
