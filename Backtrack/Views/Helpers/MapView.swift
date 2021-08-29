/*
See LICENSE for this file's licensing information.
*/

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {  //map view for visualizing data
    var points : [DataPoint]
    let dateFormatter = DateFormatter()
    
    //calculate the center of all data points
    var centerOfPoints : (center: CLLocationCoordinate2D, span: MKCoordinateSpan) {
        var minLat = 91.0
        var maxLat = -91.0
        var minLon = 181.0
        var maxLon = -181.0
        
        for i in points {
            maxLat = max(maxLat, i.coordinates.latitude)
            minLat = min(minLat, i.coordinates.latitude)
            maxLon = max(maxLon, i.coordinates.longitude)
            minLon = min(minLon, i.coordinates.longitude)
        }
        
        let center = CLLocationCoordinate2D(latitude: (maxLat + minLat) / 2,
                                           longitude: (maxLon + minLon) / 2)
        
        let span = MKCoordinateSpan(latitudeDelta: abs(maxLat - minLat) * 1.3,
                                    longitudeDelta: abs(maxLon - minLon) * 1.3)
        return (center: center,
                span: span)
    }

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero) //make UIKit map view
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        
        let center = centerOfPoints
        dateFormatter.dateFormat = "M/dd h:mm a"
        
        //configure map view
        uiView.mapType = MKMapType.satellite // (satellite)
        let region = MKCoordinateRegion(center: center.center, span: center.span)
        uiView.setRegion(region, animated: true)
        uiView.showsUserLocation = true
        //add margin at the top to compensate for date selection UI
        uiView.layoutMargins = UIEdgeInsets(top: 150, left: 10, bottom: 10, right: 10)
        
        //for each data point, add an annotation on the map with the associated info
        for point in points{
            let annotation = MKPointAnnotation()
            annotation.coordinate = point.locationCoordinate
            annotation.title = dateFormatter.string(from: point.id)
            annotation.subtitle = point.device
            uiView.addAnnotation(annotation)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(points: [DataPoint(id: Date(), device:"Test", coordinates: DataPoint.Coordinates(latitude:42.175898, longitude: -72.509578))])
    }
}
