//
//  EditarViewController.swift
//  notas
//
//  Created by Mac8 on 18/04/21.
//

import UIKit

class EditarViewController: UIViewController {
    
    var notas: [String]?
    
    var recibirNota: String?
    
    var pocision: Int?
    
    let defaultsDB = UserDefaults.standard
    
    
    
    @IBOutlet weak var editarNotaTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        editarNotaTextField.text = recibirNota
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

   
    @IBAction func guardarButton(_ sender: UIButton) {
        
        //Eliminar del arreglo de notas, la nota a editar
        notas?.remove(at: pocision!)
        
        if let notaEditada = editarNotaTextField.text {
            //Utilizamos el metodo insert para insertar la nota modificada y se quede en la posicion que estaba anteriormente)
            notas?.insert(notaEditada, at: pocision!)
        }
        
        print("arreglo de notas: \(notas)")
        
        defaultsDB.set(notas, forKey: "notas")
        navigationController?.popToRootViewController(animated: true)    }
    
    // Ocultar teclado al clickear fuera.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


