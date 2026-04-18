//
//  ManagedPlace.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 27/02/2026.
//


import CoreData

@objc(ManagedPlace)
class ManagedPlace: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String?
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var savedTimestamp: Date
    @NSManaged var imagesPath: String?
    @NSManaged var videosPath: String?
    @NSManaged var note: String?
    @NSManaged var backgroundColor: String?
}

extension ManagedPlace {
    static func fetch(in context: NSManagedObjectContext) throws -> [ManagedPlace] {
        guard let entityName = entity().name else { return [] }
        let request = NSFetchRequest<ManagedPlace>(entityName: entityName)
        return try context.fetch(request)
    }
    
    var local: LocalPlace {
        return LocalPlace(
            id: id,
            name: name,
            latitude: latitude.doubleValue,
            longitude: longitude.doubleValue,
            savedTimestamp: savedTimestamp,
            imagesPath: imagesPath,
            videosPath: videosPath,
            note: note,
            backgroundColor: backgroundColor
        )
    }
}

extension ManagedPlace {
    static func delete(by id: String, in context: NSManagedObjectContext) throws {
        let request = NSFetchRequest<ManagedPlace>(entityName: "ManagedPlace")
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

extension ManagedPlace {
    static func insert(_ place: LocalPlace,  in context: NSManagedObjectContext) throws {
        let managedPlace = ManagedPlace(context: context)
        managedPlace.id = place.id
        managedPlace.name = place.name
        managedPlace.latitude = place.latitude.toNSNumber
        managedPlace.longitude = place.longitude.toNSNumber
        managedPlace.savedTimestamp = place.savedTimestamp
        managedPlace.imagesPath = place.imagesPath
        managedPlace.videosPath = place.videosPath
        managedPlace.note = place.note
        managedPlace.backgroundColor = place.backgroundColor
        
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

extension Array where Element == ManagedPlace {
    var localPlaces: [LocalPlace] {
        return map { $0.local }
    }
}
