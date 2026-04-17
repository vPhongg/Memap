//
//  SceneDelegate.swift
//  MemapApp
//
//  Created by Vu Dinh Phong on 13/02/2026.
//

import UIKit
import SwiftUI
import MemapPresentation
import MemapData
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let localPlaceLoader = makeLocalPlaceLoader()
        let remotePlaceLoader = makeRemotePlaceLoader()
        let mapHostingController = MainViewComposer.composed(loader: localPlaceLoader, cache: localPlaceLoader, deletor: localPlaceLoader)
        window?.rootViewController = mapHostingController
        window?.makeKeyAndVisible()
    }
    
    private func makeLocalPlaceLoader() -> LocalPlaceLoader {
        let localStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("memap-store.sqlite")
        let store = try! CoreDataMemapStore(storeURL: localStoreURL)
        return LocalPlaceLoader(store: store)
    }
    
    private func makeRemotePlaceLoader() -> RemotePlaceLoader {
        let url = URL(string: "http://localhost:3000/places")!
        let client = URLSessionHTTPClient()
        return RemotePlaceLoader(url: url, client: client, mode: .withCheckedContinuation)
    }

}

