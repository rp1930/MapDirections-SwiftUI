//
//  MapDirectionsView.swift
//  MapDirections
//

import MapKit
import SwiftUI


// MARK: - MapDirectionsView

struct MapDirectionsView: View {
    
    
    // MARK: - Variables
    
    @State private var directions: [String] = []
    @State private var showDirections = false
    
    var body: some View {
        
        VStack {
            
            Text("Route & Directions")
                .font(.title)
                .bold()
                .padding()
            
            MapView(directions: $directions)
                .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
            
            Button(action: {
                
                self.showDirections.toggle()
            }, label: {
                
                Text("Show Directions")
                    .font(.title2)
                    .foregroundColor(.black)
            })
            .disabled(directions.isEmpty)
            .padding()
        }.sheet(isPresented: $showDirections, content: {
            
            VStack {
                
                Text("Directions")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Divider().background(Color.black)
                
                List {
                    
                    ForEach(0..<self.directions.count, id: \.self) { i in
                        
                        Text(self.directions[i])
                            .padding()
                    }
                }
            }
        })
    }
}


// MARK: - PreviewProvider

struct MapDirectionsView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        MapDirectionsView()
    }
}


// MARK: - UIViewRepresentable for MapView

struct MapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    @Binding var directions: [String]
    
    func makeCoordinator() -> MapViewCoordinator {
        
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.657331, longitude: -7.913843),
                                        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        let mapMarkerMidoes = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.3972036,
                                                                             longitude: -7.9703518))
        let annotationMidoes = MKPointAnnotation()
        annotationMidoes.coordinate = mapMarkerMidoes.coordinate
        annotationMidoes.title = "Midões"
        
        let mapMarkerSatao = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.7458492,
                                                                            longitude: -7.7657751))
        let annotationSatao = MKPointAnnotation()
        annotationSatao.coordinate = mapMarkerSatao.coordinate
        annotationSatao.title = "Satão"
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: mapMarkerMidoes)
        directionsRequest.destination = MKMapItem(placemark: mapMarkerSatao)
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { (response, error) in
            
            guard let directionsRoute = response?.routes.first else { return }
            mapView.addAnnotations([annotationMidoes, annotationSatao])
            
            mapView.addOverlay(directionsRoute.polyline)
            mapView.setVisibleMapRect(directionsRoute.polyline.boundingMapRect,
                                      edgePadding: UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60),
                                      animated: true)
            
            self.directions = directionsRoute.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
        
        mapView.setRegion(region, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}
