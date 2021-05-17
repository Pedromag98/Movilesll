//
//  ClimaModelo.swift
//  ClimaApp
//
//  Created by Mac8 on 30/04/21.
//

import Foundation

struct ClimaModelo {
    let temp: Double
    let sens: Double
    let hum: Double
    let con: String
    let nombreCiudad: String
    let id: Int
    
    //propiedades calculadas
    var tempString: String{
        return String(format: "%.1f", temp)
    }
    
    var sensString: String{
        return String(format: "%.1f", sens)
    }
    
    var humString: String{
        return String(format: "%.1f", hum)
    }
    
    var condicionClima: String {
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.hail"
        case 500...531:
            return "cloud.sleet"
        case 600...622:
            return "snow"
        case 701...781:
            return "sun.dust"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.sun"
        default:
            return "cloud"
        }
    }
}
