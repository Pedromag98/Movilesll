//
//  climaManager.swift
//  ClimaApp
//
//  Created by Mac8 on 28/04/21.
//

import Foundation
import CoreLocation

protocol ClimaManagerDelegado {
    func actualizarClima(clima: ClimaModelo)
    
    func huboError(erro: Error)
}

struct ClimaManager {
    let climaURL = "https://api.openweathermap.org/data/2.5/weather?appid=c9c9b1bf8d3d9951dde52c2764d0a650&units=metric&lang=es"
    
    
    //quien sea el delegado debera implementar este protocolo
    var delegado: ClimaManagerDelegado?
    
    func buscarClima (ciudad: String) {
        let urlString = "\(climaURL)&q=\(ciudad)"
        realizarSolicitud(urlString: urlString)
    }
    
    func buscarClimaGPS(lat: CLLocationDegrees, long: CLLocationDegrees){
        let urlString = "\(climaURL)&lat=\(lat)&lon=\(long)"
        realizarSolicitud(urlString: urlString)
    }
    
    func realizarSolicitud(urlString: String ){
        //1.- Crear una URL
        if let url = URL(string: urlString){
            //2.- Crear una URLSession
            let session = URLSession(configuration: .default)
            //3.- Asignarle una tarea a la URLSession
            let tarea = session.dataTask(with: url) { (datos, respuesta, error) in
                if error != nil {
                    self.delegado?.huboError(erro: error!)
                    return
                }
                
                if let datosSeguros = datos {
                    //Parsear JSON
                    if let objClima = self.passearJSON(datosClima: datosSeguros){
                        
                        //mandar ese obj a VC princpial
//                        let ClimaVC = ClimaViewController()
//                        ClimaVC.actualizarClima(objClima: objClima)
                        
                        //Designar un delegado
                        
                        self.delegado?.actualizarClima(clima: objClima)
                        
                    }
                }
                
            }
            
            //4.- Iniciar la tarea
            tarea.resume()
        }
    }
    
    func passearJSON(datosClima: Data) -> ClimaModelo? {
        //crear un decodificador JSON
        let decodificador = JSONDecoder()
        do {
            let datosDecodificados = try decodificador.decode(ClimaDatos.self, from: datosClima)
            //Imprimir los datos de la API en un formato especificio u ordenados
            
            let id = datosDecodificados.weather[0].id
            let ciudad = datosDecodificados.name
            let condicion = datosDecodificados.weather[0].description
            let temp = datosDecodificados.main.temp
            let sens = datosDecodificados.main.feels_like
            let hum = datosDecodificados.main.humidity
            
            let objClima = ClimaModelo(temp: temp,sens: sens, hum: hum,con: condicion, nombreCiudad: ciudad, id: id)
            
            return objClima

        } catch  {
            delegado?.huboError(erro: error)
            return nil
        }
    }
    
}


