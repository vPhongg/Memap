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
    var items: [PlaceAnnotation]
    let didSelectMapItem: MapItemSelectionHandler
    let didDeselectMapKitPOI: MapItemDeselectionHandler
    
    // MARK: Internal Data
    private let locationManager = CLLocationManager()
    private var hasCenteredUserLocation = false
    private var selectedPOI: MKAnnotation?
    
    // MARK: Init Methods
    public init(
        items: [PlaceAnnotation],
        didSelectMapItem: @escaping MapItemSelectionHandler,
        didDeselectMapKitPOI: @escaping MapItemDeselectionHandler
    ) {
        self.items = items
        self.didSelectMapItem = didSelectMapItem
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
    }
    
    // MARK: Custom Methods
    
    func updateItems(_ newItems: [PlaceAnnotation]) {
        let oldIDs = items.map(\.id)
        let newIDs = newItems.map(\.id)
        guard oldIDs != newIDs else { return }
        
        mapView.removeAnnotations(self.items)
        self.items = newItems
        mapView.addAnnotations(newItems)
    }
    
    func deselectSelectedPOI() {
        mapView.deselectAnnotation(selectedPOI, animated: true)
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
        handleSelected(annotation)
    }
    
    public func mapView(_ mapView: MKMapView, didDeselect annotation: any MKAnnotation) {
        didDeselectMapKitPOI()
    }
    
    // MARK: - Helpers
    
    private func handleSelected(_ annotation: MKAnnotation) {
        switch annotation {
        case let cluster as MKClusterAnnotation:
            zoomToCluster(cluster, in: mapView)
            
        case let placeAnnotation as PlaceAnnotation:
            didSelectMapItem(MMapItem.from(placeAnnotation))
            
        case let poi as MKMapFeatureAnnotation:
            didSelectMapItem(MMapItem.from(poi))
            
        default:
            break
        }
    }
    
    private func zoomToCluster(_ cluster: MKClusterAnnotation, in mapView: MKMapView) {
        let inset: CGFloat = 80
        let annotations = cluster.memberAnnotations
        
        var zoomRect = MKMapRect.null
        
        for annotation in annotations {
            let point = MKMapPoint(annotation.coordinate)
            let rect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
            zoomRect = zoomRect.union(rect)
        }
        
        let edgePadding = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        UIView.animate(withDuration: 0.39) {
            mapView.setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: true)
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
