//
//  ViewController.swift
//  buscadorMapas
//
//  Created by Mac8 on 06/05/21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var buscadorSB: UISearchBar!
    @IBOutlet weak var MapaMK: MKMapView!
    
    var latitud: CLLocationDegrees?
    var longitud: CLLocationDegrees?
    var altitud: Double?
    
    //Manager para hacer uso del GPS
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buscadorSB.delegate = self
        
        manager.delegate = self
        
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        
        MapaMK.delegate = self
        
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.startUpdatingLocation()
        
    }
    
    //MARK:- Trazar la ruta
    func trazarRuta(coordenadasDestino: CLLocationCoordinate2D){
        guard let coordOrigen = manager.location?.coordinate else { return }
        //Crear un lugar de origen-destino
        let origenPlaceMark = MKPlacemark(coordinate: coordOrigen)
        let destinoPlaceMark = MKPlacemark(coordinate: coordenadasDestino)
        
        let point1 = CLLocation (latitude: latitud!, longitude: longitud!)
        let point2 = CLLocation(latitude: coordenadasDestino.latitude, longitude: coordenadasDestino.longitude)
        
        let distance = point1.distance(from: point2) / 1000
        print(String(format: "La distancia es %.01fkm", distance))
        
        //Crear un objeto mapkit Item
        let origenItem = MKMapItem(placemark: origenPlaceMark)
        let destinoItem = MKMapItem(placemark: destinoPlaceMark)
        
        //solicitud de ruta
        let solicitudDestino = MKDirections.Request()
        solicitudDestino.source = origenItem
        solicitudDestino.destination = destinoItem
        
        //Como se va a viajar
        solicitudDestino.transportType = .automobile
        solicitudDestino.requestsAlternateRoutes = true
        
        let direcciones = MKDirections(request: solicitudDestino)
        direcciones.calculate { (respuesta: MKDirections.Response?, error: Error?) in
            //Variable segura
            guard let respuestaSegura = respuesta else{
                if let error = error {
                    print("Error al calcular la ruta \(error.localizedDescription)")
                }
                return
            }
            
            //Si todo salio bien
            print(respuestaSegura.routes.count)
            let ruta = respuestaSegura.routes[0]
            
            
            
            //Agregar al mapa una superposicion
            self.MapaMK.addOverlay(ruta.polyline)
            self.MapaMK.setVisibleMapRect(ruta.polyline.boundingMapRect, animated: true)
            
            //Alerta para mostrar la distancia
            let alerta = UIAlertController(title: "Distancia", message: String(format: "\nLa distancia desde tu ubicacion \n\n hacia \(self.buscadorSB.text!) \n\n es de %.02f km", distance), preferredStyle: .alert)
            
            let accionAceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            
            alerta.addAction(accionAceptar)
            
            self.present(alerta, animated: true)
            
            
        }
    }
    
    //Metodo de ayuda para poder agregar la superposicion al mapa
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderizado = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderizado.strokeColor = .red
        return renderizado
    }


    @IBAction func UbicacionButton(_ sender: UIBarButtonItem) {
        
        let alerta = UIAlertController(title: "Ubicacion", message: "\nLas coordenadas son: \n\n Latitud: \(latitud ?? 0) \n\n Longitud \(longitud ?? 0) \n\n Altitud: \(altitud ?? 0)", preferredStyle: .alert)
        
        let accionAceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        
        alerta.addAction(accionAceptar)
        
        present(alerta, animated: true)
        
        let localizacion = CLLocationCoordinate2D(latitude: latitud!, longitude: longitud!)
        
        let spanMapa = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        
        let region = MKCoordinateRegion(center: localizacion, span: spanMapa)
        
        MapaMK.setRegion(region, animated: true)
        MapaMK.showsUserLocation = true
    }
}


extension ViewController: CLLocationManagerDelegate, UISearchBarDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //print("Numero de ubicaciones \(locations.count)")
        
        guard let ubicacion = locations.first else{
            return
        }
        
        latitud = ubicacion.coordinate.latitude
        longitud = ubicacion.coordinate.longitude
        
        altitud = ubicacion.altitude

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener ubicacion \(error.localizedDescription)")
               
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Metodo para ocultar el teclado
        buscadorSB.resignFirstResponder()
        
        let geocoder = CLGeocoder()
        
        if let direccion = buscadorSB.text {
            geocoder.geocodeAddressString(direccion) { (places: [CLPlacemark]?, error: Error?) in
                
                //Crear el destino
                guard let destinoRuta = places?.first?.location else {return}
                
                if error == nil{
                    print("Ubicacion Encontrada!")
                    
                    //Buscar la direccion en el mapa
                    let lugar = places?.first
                    let anotacion = MKPointAnnotation()
                    anotacion.coordinate = (lugar?.location?.coordinate)!
                    anotacion.title = direccion
                    
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    
                    let region = MKCoordinateRegion(center: anotacion.coordinate, span: span)
                    
                    self.MapaMK.setRegion(region, animated: true)
                    self.MapaMK.addAnnotation(anotacion)
                    self.MapaMK.selectAnnotation(anotacion, animated: true)
                    
                    //mandar llamar a trazar ruta
                    self.trazarRuta(coordenadasDestino: destinoRuta.coordinate)
                    
                    
                    
                
                } else{
                    
                    print("Error al encontrar la direccion \(error?.localizedDescription)")
                }
            }
        }
    }
    
    
}
