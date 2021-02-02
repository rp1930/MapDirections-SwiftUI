//
//  MapDirectionsView+Extensions.swift
//  MapDirections
//

import MapKit
import SwiftUI

extension MapView {
    
    
    // MARK: - MKMapViewDelegate
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .orange
            polylineRenderer.lineWidth = 2
            return polylineRenderer
        }
    }
}
