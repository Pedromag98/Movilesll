//
//  ViewController.swift
//  propinas
//
//  Created by Mac8 on 20/03/21.
//

import UIKit

class ViewController: UIViewController {
    
    var cerebroPropi = cerebroPropina()
    
    @IBOutlet weak var tituloApp: UILabel!
    @IBOutlet weak var totalcuentaTextField: UITextField!
    @IBOutlet weak var tituloporcentajeLabel: UILabel!
    @IBOutlet weak var changeValueSlider: UILabel!
    @IBOutlet weak var porcentajeSlider: UISlider!
    @IBOutlet weak var titulopersonasLabel: UILabel!
    @IBOutlet weak var changeValuePersonasSlider: UILabel!
    @IBOutlet weak var personasSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Ocultar teclado al clickear fuera.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    @IBAction func calcularButton(_ sender: UIButton) {
     
        let cuenta = (totalcuentaTextField.text! as NSString).floatValue
        let porcentaje = porcentajeSlider.value
        let personas = personasSlider.value
        
        cerebroPropi.calcularPropina(cuenta: cuenta, porcentaje: Int(porcentaje), personas: Int(personas))
        
        performSegue(withIdentifier: "enviarCantidad", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enviarCantidad" {
            let objDestinoVC = segue.destination as! SecondViewController
            objDestinoVC.recibirCuenta = cerebroPropi.retornaValorPropina()

        }
    }
    
    
    @IBAction func porcentajeAction(_ sender: UISlider) {
        changeValueSlider.text  = "\(Int(sender.value))"
    }
    @IBAction func personasAction(_ sender: UISlider) {
        changeValuePersonasSlider.text = "\(Int(sender.value))"
    }
}
    
    

