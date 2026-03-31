//
//  ManagedPlaceInfo.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 27/02/2026.
//


import CoreData

@objc(ManagedPlaceInfo)
class ManagedPlaceInfo: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String?
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var savedTimestamp: Date
    @NSManaged var imagesPath: String?
    @NSManaged var videosPath: String?
    @NSManaged var note: String?
}

extension ManagedPlaceInfo {
    static func fetch(in context: NSManagedObjectContext) throws -> [ManagedPlaceInfo] {
        guard let entityName = entity().name else { return [] }
        let request = NSFetchRequest<ManagedPlaceInfo>(entityName: entityName)
        return try context.fetch(request)
    }
    
    var local: LocalPlaceInfo {
        return LocalPlaceInfo(
            id: id,
            name: name,
            latitude: latitude.doubleValue,
            longitude: longitude.doubleValue,
            imagesPath: imagesPath,
            videosPath: videosPath,
            note: note
        )
    }
}

extension ManagedPlaceInfo {
    static func delete(by id: UUID, in context: NSManagedObjectContext) throws {
        let request = NSFetchRequest<ManagedPlaceInfo>(entityName: "ManagedPlaceInfo")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            try context.fetch(request).first.map(context.delete).map(context.save)
        } catch {
            context.rollback()
            throw error
        }
    }
}

extension ManagedPlaceInfo {
    static func insert(_ place: LocalPlaceInfo,  in context: NSManagedObjectContext) throws {
        let managedPlace = ManagedPlaceInfo(context: context)
        managedPlace.id = place.id
        managedPlace.name = place.name
        managedPlace.latitude = place.latitude.toNSNumber
        managedPlace.longitude = place.longitude.toNSNumber
        managedPlace.savedTimestamp = Date()
        managedPlace.imagesPath = place.imagesPath
        
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
}

extension Double {
    var toNSNumber: NSNumber {
        NSNumber(value: self)
    }
}

extension Array where Element == ManagedPlaceInfo {
    var localPlaces: [LocalPlaceInfo] {
        return map { $0.local }
    }
}
