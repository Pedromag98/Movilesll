//
//  ViewController.swift
//  notas
//
//  Created by Mac8 on 18/04/21.
//

import UIKit

class ViewController: UIViewController{
    
    var notaEditar: String?
    
    let defaultsDB = UserDefaults.standard
    
    var notas = ["Ir al super", "Estudiar","Fornite","Ir al mercado"]
    
    var fechas = [""]
    
    var pocision: Int?
    
    
    @IBOutlet weak var tablaNotas: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tablaNotas.delegate = self
        tablaNotas.dataSource = self
        
        if let arregloNotas = defaultsDB.array(forKey: "notas") as? [String] {
            notas = arregloNotas
        } else {
            notas = [""]
        }
        if let fechasArray = defaultsDB.array(forKey: "fechas") as? [String] {
            fechas = fechasArray
        }
        print(defaultsDB.array(forKey: "notas"))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let arregloNotas = defaultsDB.array(forKey: "notas") as? [String] {
            notas = arregloNotas
        }
        tablaNotas.reloadData()
        print("Se llamo al metodo viewWillAppear")
    }

    
    @IBAction func addNotaButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alerta = UIAlertController(title: "Agregar", message: "Nueva nota", preferredStyle: .alert)
        
        let accion = UIAlertAction(title: "Aceptar", style: .default) {(_) in
            print("Nota Agregada!")
            self.notas.append(textField.text ?? "Valor vacio")
            
            let date = Date()
            
            let dateFormatter = DateFormatter()
            
            //formateamos la fecha a español
            dateFormatter.locale = Locale(identifier: "es_MX")

            
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .medium
            
            let fechaFormato = dateFormatter.string(from: date)
            
            self.fechas.append("Fecha: \(fechaFormato)")
            
            print(self.notas)
            
            //Guardando en la BD el arreglo notas
            self.defaultsDB.set(self.notas,forKey: "notas")
            //Guardando en la BD el arreglo de fechas
            self.defaultsDB.set(self.fechas, forKey: "fechas")
            
            self.tablaNotas.reloadData()
        }
        
        let accionCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alerta.addAction(accionCancelar)
        alerta.addAction(accion)
        
        alerta.addTextField { (textFieldAlerta) in
        textFieldAlerta.placeholder = "agregar nota..."
            textField = textFieldAlerta
        }
        
        present(alerta, animated: true, completion: nil)

    }
}
    
    

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaNotas.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        
        celda.textLabel?.text = notas[indexPath.row]
        celda.detailTextLabel?.text = fechas[indexPath.row]
                    
        return celda
    }
    
    //Metodo para identificar la posicion de la tabla seleccionada
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(notas[indexPath.row])
        
        pocision = indexPath.row
        
        notaEditar = notas[indexPath.row]
        performSegue(withIdentifier: "editar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar" {
            let objEditar = segue.destination as! EditarViewController
            objEditar.recibirNota = notaEditar
            objEditar.notas = notas
            objEditar.pocision = pocision
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Eliminar objeto: \(notas[indexPath.row])")
            notas.remove(at: indexPath.row)
            //al eliminar una nota tambien eliminamos la fecha del array de fechas para que no se quede guardada.
            fechas.remove(at: indexPath.row)
            print(notas)
            
            tablaNotas.reloadData()
            
            self.defaultsDB.set(self.notas, forKey: "notas")
         
           
            
        }
    }
}
