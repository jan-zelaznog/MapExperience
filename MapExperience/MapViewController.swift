//
//  MapViewController.swift
//  MapExperience
//
//  Created by Ángel González on 28/05/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    var elMapa = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elMapa.frame = self.view.bounds
        self.view.addSubview(elMapa)
        elMapa.mapType = .standard
        elMapa.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let ad = UIApplication.shared.delegate as! AppDelegate
        elMapa.setRegion(MKCoordinateRegion(center: ad.miUbicacion, latitudinalMeters: 100, longitudinalMeters: 100), animated: true)
        // colocamos un pin para que sea claro para el usuario
        let elPin = MKPointAnnotation()
        elPin.coordinate = ad.miUbicacion
        elPin.title = "Usted está aquí"
        elMapa.addAnnotation(elPin)
        
        let coord1 = CLLocationCoordinate2D(latitude: 19.42612, longitude: -99.59977)
        let elPin1 = MKPointAnnotation()
        elPin1.coordinate = coord1
        elPin1.title = "Inicio"
        elMapa.addAnnotation(elPin1)
        let coord2 = CLLocationCoordinate2D(latitude: 19.42539, longitude: -99.59878)
        let elPin2 = MKPointAnnotation()
        elPin2.coordinate = coord2
        elPin2.title = "Fin"
        elMapa.addAnnotation(elPin2)
        elMapa.setRegion(regionFor(coordinates: [ad.miUbicacion, coord1, coord2]), animated: true)
        let linea = MKPolyline(coordinates: [ad.miUbicacion, coord1, coord2], count:3)
        elMapa.addOverlay(linea)
    }

    // Este método se invoca cuando se le agrega cualquier overlay al mapa
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        render.strokeColor = .blue
        render.lineWidth = 2
        return render
    }
    
    func regionFor (coordinates:[CLLocationCoordinate2D])-> MKCoordinateRegion {
        var minLat:CLLocationDegrees = 90.0
        var maxLat = -90.0;
        var minLon = 180.0;
        var maxLon = -180.0;
        for coordinate in coordinates {
            if (coordinate.latitude < minLat) {
                minLat = coordinate.latitude
            }
            if (coordinate.longitude < minLon) {
                minLon = coordinate.longitude
            }
            if (coordinate.latitude > maxLat) {
                maxLat = coordinate.latitude
            }
            if (coordinate.longitude > maxLon) {
                maxLon = coordinate.longitude
            }
        }
        let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat, longitudeDelta: maxLon - minLon)
        let center = CLLocationCoordinate2D(latitude: (maxLat - span.latitudeDelta / 2), longitude: maxLon - span.longitudeDelta / 2)
        return MKCoordinateRegion(center: center, span: span)
    }
}
