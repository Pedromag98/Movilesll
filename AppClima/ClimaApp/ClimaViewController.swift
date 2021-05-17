//
//  ViewController.swift
//  ClimaApp
//
//  Created by marco rodriguez on 01/04/21.
//

import UIKit
import CoreLocation

class ClimaViewController: UIViewController, UITextFieldDelegate, ClimaManagerDelegado, CLLocationManagerDelegate{
    
    var latitud: CLLocationDegrees?
    var longitud: CLLocationDegrees?
    
    func huboError(erro: Error) {
        print (erro.localizedDescription)
        DispatchQueue.main.async {
            let alerta = UIAlertController(title: "ERROR", message: "Ciudad no encontrada!", preferredStyle: .alert)
            let accionOk = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alerta.addAction(accionOk)
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    var climaManager = ClimaManager()
    //Ayudar a obtener las coordenadas o la ubicacion
    var climaLocationManager = CLLocationManager()
    
    @IBOutlet weak var buscarTextField: UITextField!
    @IBOutlet weak var condicionClimaImageView: UIImageView!
    @IBOutlet weak var temperaturaLabel: UILabel!
    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var condicionClima: UILabel!
    @IBOutlet weak var sensacionTermicaLabel: UILabel!
    @IBOutlet weak var humedadLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        climaLocationManager.delegate = self
        
        // solicitar el permiso del usuario para acceder a su ubicacion
        climaLocationManager.requestWhenInUseAuthorization()
        
        //rastrear la ubicacion en todo momento
        climaLocationManager.requestLocation()
        
        //Establecer esta clase como el delegado del ClimaManager
        climaManager.delegado = self
        
        buscarTextField.delegate = self
    }
    
    @IBAction func GPSButton(_ sender: UIButton) {
        if (latitud == nil) && longitud == nil{
            DispatchQueue.main.async {
                let alerta = UIAlertController(title: "ERROR", message: "No se pudo acceder a su ubicacion", preferredStyle: .alert)
                let accionOk = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                alerta.addAction(accionOk)
                self.present(alerta, animated: true, completion: nil)
            }
            
        } else {
        climaManager.buscarClimaGPS(lat: latitud!, long: longitud!)
        }
    }
    @IBAction func buscarButton(_ sender: UIButton) {
        buscarTextField.endEditing(true)
        //     print(buscarTextField.text!)
        //    ciudadLabel.text = buscarTextField.text
        
        //     buscarTextField.text = ""
    }
    
    
    //Metodos del delegado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //ocultar el teclado virtual
        buscarTextField.endEditing(true)
        //       print(buscarTextField.text!)
        ciudadLabel.text = buscarTextField.text
        buscarTextField.text = ""
        //Realizar la busqueda en la API
        
        return true
    }
    
    // Deberia permitir dejar de editar el textfield
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if buscarTextField.text != "" {
            return true
        } else {
            buscarTextField.placeholder = "Escribe algo..."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        climaManager.buscarClima(ciudad: buscarTextField.text!)
        
        buscarTextField.text = ""
    }
    
    func actualizarClima(clima: ClimaModelo) {
        
        DispatchQueue.main.async {
            self.temperaturaLabel.text = clima.tempString
            self.ciudadLabel.text = clima.nombreCiudad
            self.condicionClima.text = clima.con
            self.sensacionTermicaLabel.text = clima.sensString
            self.humedadLabel.text = clima.humString
            self.condicionClimaImageView.image = UIImage(systemName: clima.condicionClima)
        }
        
    }
    
    //MARK:- Metodos de ubicacion
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let ubicacion = locations.last {
            let latitud = ubicacion.coordinate.latitude
            let longitud = ubicacion.coordinate.longitude
            self.latitud = latitud
            self.longitud = longitud
            print("Se obtubo la ubicacion lat: \(latitud)& long:\(longitud)")
            climaManager.buscarClimaGPS(lat: latitud, long: longitud)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicacion")
    }
    
}

