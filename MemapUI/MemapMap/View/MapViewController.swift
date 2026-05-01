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
        
        if let annotation = annotation as? MKClusterAnnotation {
            let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "cluster")
            view.markerTintColor = .systemBlue
            return view
        }
        
        if let annotation = annotation as? PlaceAnnotation {
            let placeAnnotation = PlaceAnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(PlaceAnnotation.self))
            return placeAnnotation
        }
        
        return nil
        
    }
    
    public func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        handleSelected(annotation)
    }
    
    public func mapView(_ mapView: MKMapView, didDeselect annotation: any MKAnnotation) {
        didDeselectMapKitPOI()
    }
    
    // MARK: - Helpers
    
    func selectPlace(id: String?) {
        guard let annotation = mapView.annotations.first(where: { ($0 as? PlaceAnnotation)?.id == id }) else { return }
        
        let region = MKCoordinateRegion(
            center: annotation.coordinate,
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )
        
        UIView.animateDefault { [weak self] in
            self?.mapView.setRegion(region, animated: true)
//            self?.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    private func handleSelected(_ annotation: MKAnnotation) {
        switch annotation {
        case let cluster as MKClusterAnnotation:
            zoomToCluster(cluster, in: mapView)
            
        case let placeAnnotation as PlaceAnnotation:
            didSelectMapItem(MMapItem.from(placeAnnotation))
            
        case let poi as MKMapFeatureAnnotation:
            Task {
                let fullAddress = try? await getFullAddress(of: poi)
                didSelectMapItem(MMapItem.from(poi, address: fullAddress))
            }
            
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
        
        UIView.animateDefault {
            mapView.setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: true)
        }
    }
    
    private func getFullAddress(of poi: MKMapFeatureAnnotation) async throws -> String? {
        let request = MKMapItemRequest(mapFeatureAnnotation: poi)
        let mapItem = try await request.mapItem
        
        if #available(iOS 26.0, *) {
            return format(address: mapItem.addressRepresentations?.fullAddress(includingRegion: true, singleLine: true))
        } else {
            return format(address: mapItem.placemark.title)
        }
        
        func format(address: String?) -> String? {
            address?.replacingOccurrences(of: "\n", with: ", ")
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
