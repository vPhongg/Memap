//
//  MapViewController.swift
//  MemapMap
//
//  Created by Vu Dinh Phong on 09/04/2026.
//

import MapKit

public class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    private var hasCenteredUserLocation = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
    }
    
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Cycle else { return nil }

        switch annotation.type {
        case .unicycle:
            return UnicycleAnnotationView(annotation: annotation, reuseIdentifier: UnicycleAnnotationView.ReuseID)
        case .bicycle:
            return BicycleAnnotationView(annotation: annotation, reuseIdentifier: BicycleAnnotationView.ReuseID)
        case .tricycle:
            return TricycleAnnotationView(annotation: annotation, reuseIdentifier: TricycleAnnotationView.ReuseID)
        }
    }
}


// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            mapView.setUserTrackingMode(.follow, animated: true)
        }
    }
    
    var userLocationViewDistance: CLLocationDistance {
        1500
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        if !hasCenteredUserLocation {
            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: userLocationViewDistance,
                longitudinalMeters: userLocationViewDistance
            )
            mapView.setRegion(region, animated: true)
            hasCenteredUserLocation = true
        }
    }
}
