//
//  Coordinator.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 23/03/2026.
//

import MapKit

protocol MMapCoordinatorDelegate: AnyObject {
    func didSelectCustomAnnotation(_ annotation: MKAnnotation)
    func didSelectMapKitPOI(_ annotation: MKAnnotation)
}

public class MMapCoordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    weak var mapView: MKMapView?
    var delegate: MMapCoordinatorDelegate?
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation || annotation is MKMapFeatureAnnotation {
            return nil
        }
        
        let customAnnotation = CustomAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationView.ReuseID)
        if let title = annotation.title {
            customAnnotation.title = title ?? ""
        }
        customAnnotation.setupView()
        return customAnnotation
    }
    
    public func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        if annotation is MKMapFeatureAnnotation {
            delegate?.didSelectMapKitPOI(annotation)
        }
    }
    
    var hasZoomed = false
    public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard !hasZoomed else { return }
        hasZoomed = true
        
        let region = MKCoordinateRegion(
            center: userLocation.coordinate,
            latitudinalMeters: 100,
            longitudinalMeters: 100
        )
        
        mapView.setRegion(region, animated: true)
    }
}
