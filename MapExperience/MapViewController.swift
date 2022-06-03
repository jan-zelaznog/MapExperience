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
    var lineas = 0
    let colores = [UIColor.blue, UIColor.green, UIColor.orange, UIColor.yellow, UIColor.brown]
    
    //*** INTRODUCCION A COREMOTION  **/
    /// Gyroscopio implementado directamente en los métodos de la clase UIViewcontroller
    let tipos = [MKMapType.standard, MKMapType.satellite, MKMapType.hybrid]
    var index = 0
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        index += 1
        if index > 2 {
            index = 0
        }
        elMapa.mapType = tipos[index]
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        let orientacion = UIDevice.current.orientation
        print ("change! \(orientacion)")
    }
    
    ///////////////////////////////////////////
    
    override func viewWillLayoutSubviews() {
        // este método no se invoca como consecuencia del movimiento, sino como consecuencia de cualquier evento que pueda modificar la vista, por ejemplo viewWillAppear
        super.viewWillLayoutSubviews()
        print("layout")
    }
    
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
//    lat:19.3318804, lon:-99.1883468,
//    lat:19.3835004, lon:-99.1784087
        // TORRE DE RECTORIA UNAM: let coord1 = CLLocationCoordinate2D(latitude: 19.3318804, longitude: -99.1883468)
        let coord1 = CLLocationCoordinate2D(latitude: 19.3957604, longitude: -99.1788312)
        let elPin1 = MKPointAnnotation()
        elPin1.coordinate = coord1
        elPin1.title = "Inicio"
        elMapa.addAnnotation(elPin1)
        let coord2 = CLLocationCoordinate2D(latitude: 19.3835004, longitude: -99.1784087)
        let elPin2 = MKPointAnnotation()
        elPin2.coordinate = coord2
        elPin2.title = "Fin"
        elMapa.addAnnotation(elPin2)
        //elMapa.setRegion(regionFor(coordinates: [coord1, coord2]), animated: true)
        /*let linea = MKPolyline(coordinates: [ad.miUbicacion, coord1, coord2], count:3)
        elMapa.addOverlay(linea)*/
        comoLlegar(de: coord1, a:coord2)
    }

    func comoLlegar(de: CLLocationCoordinate2D, a:CLLocationCoordinate2D) {
        let indicaciones = MKDirections.Request()
        indicaciones.source = MKMapItem(placemark: MKPlacemark(coordinate: de))
        indicaciones.destination = MKMapItem(placemark: MKPlacemark(coordinate: a))
        indicaciones.transportType = .walking
        indicaciones.requestsAlternateRoutes = true
        let rutas = MKDirections(request: indicaciones)
        lineas = 0
        elMapa.removeOverlays(elMapa.overlays)
        rutas.calculate { [weak self] response, error in
            if error != nil {
                print ("ocurrió un error al solicitar directions \(error!.localizedDescription)")
            }
            guard let responseRoutes = response?.routes else { return }
            for ruta in responseRoutes {
                self?.elMapa.addOverlay(ruta.polyline)
                self?.lineas += 1
                self?.elMapa.setVisibleMapRect(ruta.polyline.boundingMapRect, animated:true)
            }
        }
    }
    
    // Este método se invoca cuando se le agrega cualquier overlay al mapa
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        render.strokeColor = colores[lineas]
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
