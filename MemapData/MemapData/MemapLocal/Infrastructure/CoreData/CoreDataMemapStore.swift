//
//  CoreDataMemapStore.swift
//  MemapData
//
//  Created by Vu Dinh Phong on 27/02/2026.
//


import CoreData

public final class CoreDataMemapStore {
    public static let modelName = "MemapStore"
    public static let model = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataMemapStore.self))
    
    let context: NSManagedObjectContext
    
    private let container: NSPersistentContainer
    
    public struct ModelNotFound: Error {
        public let modelName: String
    }
    
    public init(storeURL: URL) throws {
        guard let model = CoreDataMemapStore.model else {
            throw ModelNotFound(modelName: CoreDataMemapStore.modelName)
        }
        
        container = try NSPersistentContainer.load(
            name: CoreDataMemapStore.modelName,
            model: model,
            url: storeURL
        )
        
        context = container.newBackgroundContext()
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
}
