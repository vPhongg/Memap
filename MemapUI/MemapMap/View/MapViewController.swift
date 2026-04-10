//
//  MapViewController.swift
//  MemapMap
//
//  Created by Vu Dinh Phong on 09/04/2026.
//

import MapKit

public typealias MapItemSelectionHandler = (MMapItem) -> Void
public typealias MapItemDeselectionHandler = () -> Void

public class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: External Data
    let items: [PlaceAnnotation]
    let didSelectMapKitPOI: MapItemSelectionHandler
    let didDeselectMapKitPOI: MapItemDeselectionHandler
    
    // MARK: Internal Data
    private let locationManager = CLLocationManager()
    private var hasCenteredUserLocation = false
    
    
    // MARK: Init Methods
    public init(
        items: [PlaceAnnotation],
        didSelectMapKitPOI: @escaping MapItemSelectionHandler,
        didDeselectMapKitPOI: @escaping MapItemDeselectionHandler
    ) {
        self.items = items
        self.didSelectMapKitPOI = didSelectMapKitPOI
        self.didDeselectMapKitPOI = didDeselectMapKitPOI
        
        let bundle = Bundle(for: MapViewController.self)
        super.init(nibName: "MapViewController", bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        registerAnnotationViewClasses()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.pointOfInterestFilter = .includingAll
        mapView.selectableMapFeatures = [.physicalFeatures, .pointsOfInterest]
        mapView.addAnnotations(items)
    }
    
    // MARK: Custom Methods
    
    func updateItems(_ newItems: [PlaceAnnotation]) {
        mapView.removeAnnotations(items)
        mapView.addAnnotations(newItems)
    }
    
    private func registerAnnotationViewClasses() {
        mapView.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(PlaceAnnotation.self))
    }
    
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PlaceAnnotation else { return nil }
        
        let placeAnnotation = PlaceAnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(PlaceAnnotation.self))
        return placeAnnotation
    }
    
    public func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        
        if annotation is PlaceAnnotation {
            print("is PlaceAnnotation")
        }
        
        if let annotation = annotation as? PlaceAnnotation {
            print("annotation as? PlaceAnnotation")
        }
        
        if let annotation = annotation as? MKMapFeatureAnnotation {
            didSelectMapKitPOI(MMapItem.from(annotation))
        }
    }
    
    public func mapView(_ mapView: MKMapView, didDeselect annotation: any MKAnnotation) {
        didDeselectMapKitPOI()
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
