//
//  MMapView.swift
//  MemapMap
//
//  Created by Vu Dinh Phong on 09/04/2026.
//

import SwiftUI

struct MMapView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MapViewController {
        let bundle = Bundle(for: MapViewController.self)
        return MapViewController(nibName: "MapViewController", bundle: bundle)
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        // update data if needed
    }
}

#Preview {
    MMapView()
}
