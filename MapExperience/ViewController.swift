//
//  ViewController.swift
//  MapExperience
//
//  Created by Ángel González on 28/05/22.
//

import UIKit
import CoreLocation
// chip GPS
// triangulación con torres de Cell
// rastreo de redes WiFi


class ViewController: UIViewController, CLLocationManagerDelegate {

    var admUbicacion = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // La precisión de la lectura, impacta el rendimiento de la batería
        admUbicacion.desiredAccuracy = kCLLocationAccuracyHundredMeters
        admUbicacion.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Verificamos si la geolocalización está activada
        if CLLocationManager.locationServicesEnabled() {
            switch admUbicacion.authorizationStatus {
                case .notDetermined: admUbicacion.requestAlwaysAuthorization()
                case .restricted:
                    let alert = UIAlertController(title: "Error", message: "Se requiere su permiso para usar la ubicación, Autoriza ahora?", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "SI", style: UIAlertAction.Style.default, handler: { action in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, options: [:],completionHandler:nil)
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                default: admUbicacion.startUpdatingLocation()
            }
        }
        else {
            // ?
        }
    }

    // LocationManager Delegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            admUbicacion.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // solo se necesitaba una ubicación?
        admUbicacion.stopUpdatingLocation()
        // que hacemos con la ubicación?
        // las ubicaciones obtenidas se ordenan de la mejor a la peor, asi que tomamos la primera
        guard let ubicacion = locations.first else { return }
        // hacemos una referencia a la clase AppDelegate para buscar la ubicación y actualizarla
        let ad = UIApplication.shared.delegate as! AppDelegate
        // ad.miUbicacion = ubicacion.coordinate
        //
        let textView = UITextView()
        textView.frame = self.view.frame.insetBy(dx: 30, dy: 100)
        self.view.addSubview(textView)
        print ("\(ubicacion.coordinate.latitude), \(ubicacion.coordinate.longitude)")
        CLGeocoder().reverseGeocodeLocation(ubicacion) { lugares, error in
            var direccion = ""
            if error != nil {
                print ("no se pudo encontrar la dirección correspondiente a esa coordenada")
            }
            else {
                guard let lugar = lugares?.first else { return }
                let thoroughfare = (lugar.thoroughfare ?? "")
                let subThoroughfare = (lugar.subThoroughfare ?? "")
                let locality = (lugar.locality ?? "")
                let subLocality = (lugar.subLocality ?? "")
                let administrativeArea = (lugar.administrativeArea ?? "")
                let subAdministrativeArea = (lugar.subAdministrativeArea ?? "")
                let postalCode = (lugar.postalCode ?? "")
                let country = (lugar.country ?? "")
                direccion = "Dirección: \(thoroughfare) \(subThoroughfare) \(locality) \(subLocality) \(administrativeArea) \(subAdministrativeArea) \(postalCode) \(country)"
                textView.text = "Usted está en: \(ubicacion.coordinate.latitude), \(ubicacion.coordinate.longitude)\n" + direccion
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Que sigue?
        // no se pueden obtener lecturas que cumplan con la precisión deseada
        admUbicacion.stopUpdatingLocation()
    }
}

