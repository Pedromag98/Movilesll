//
//  cerebroPropina.swift
//  propinas
//
//  Created by Mac8 on 23/03/21.
//

import Foundation

struct cerebroPropina {
    
    var propi: propina?
    
    func retornaValorPropina() -> String{
        let valorPropina = String ( format:  "%.2f", propi?.valor ?? 0.0)
        return valorPropina
    }
    mutating func calcularPropina(cuenta: Float, porcentaje: Int, personas: Int){
        let resultado = (cuenta+(cuenta*(Float(porcentaje)*0.01)))/Float(personas)
        propi = propina(valor: resultado)
    }
}
