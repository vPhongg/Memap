//
//  CustomAnnotationView.swift
//  MemapUI
//
//  Created by Vu Dinh Phong on 23/03/2026.
//

import MapKit
import SwiftUI

class CustomAnnotationView: MKAnnotationView {
    
    static let ReuseID = "customAnnotationView"
    
    var title: String = ""
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "customAnnotation"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        let view = PlaceMarkerView(
            title: self.title,
            size: 29,
            isActive: false
        )
        
        let controller = UIHostingController(rootView: view)
        addSubview(controller.view)
    }
    
}
