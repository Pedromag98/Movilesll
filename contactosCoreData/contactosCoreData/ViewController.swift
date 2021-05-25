//
//  ViewController.swift
//  contactosCoreData
//
//  Created by Mac8 on 22/05/21.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    var nombreEnviar: String?
    var telefonoEnviar: Int64?
    var direccionEnviar: String?
    var correoEnviar: String?
    var indice: Int?
    
    var contactos = [Contacto]()
    
    //Conexion al contexto de la BD
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var tablaContactos: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //leer los datos de la db de core data
        cargarCoreData()
        tablaContactos.reloadData()
        
        tablaContactos.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tablaContactos.reloadData()
    }

    @IBAction func agregarContactoButton(_ sender: UIBarButtonItem) {
        let alerta = UIAlertController(title: "Agregar", message: "Nuevo Contacto", preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "Agregar", style: .default) { (_) in
            
            
            
            
            guard let nombreAlert = alerta.textFields?.first?.text else { return }
            guard let telefonoAlert = Int64(alerta.textFields?[1].text ?? "000000") else { return }
            guard let DireccionAlert = alerta.textFields?[2].text else { return }
            guard let correoAlert = alerta.textFields?.last?.text else { return }
            
            
            let imagenTemporal = UIImageView(image: #imageLiteral(resourceName: "anonimo"))
            
            
            //crear el objeto para guardar en coredata
            let nuevoContacto = Contacto(context: self.contexto)
            nuevoContacto.nombre = nombreAlert
            nuevoContacto.telefono = telefonoAlert
            nuevoContacto.direccion = DireccionAlert
            nuevoContacto.correo = correoAlert
            nuevoContacto.imagen = imagenTemporal.image!.pngData()
            
            
            self.contactos.append(nuevoContacto)
            
            self.guardarContacto()
            
            self.tablaContactos.reloadData()
        }
        
        alerta.addTextField {(nombreTF) in
            nombreTF.placeholder = "Nombre"
            nombreTF.textColor = .black
            nombreTF.textAlignment = .center
            nombreTF.autocapitalizationType = .words
        }
        alerta.addTextField {(telefonoTF) in
            telefonoTF.placeholder = "Telefono"
            telefonoTF.textColor = .blue
            telefonoTF.keyboardType = .numberPad
            telefonoTF.textAlignment = .center
            telefonoTF.autocapitalizationType = .words
        }
        alerta.addTextField {(direccionTF) in
            direccionTF.placeholder = "Direccion"
            direccionTF.textColor = .darkGray
            direccionTF.textAlignment = .center
            direccionTF.autocapitalizationType = .words
            
        }
        alerta.addTextField {(correoTF) in
            correoTF.placeholder = "Correo"
            correoTF.textColor = .darkGray
            correoTF.textAlignment = .center
            correoTF.keyboardType = .emailAddress
        }
        alerta.addAction(accionAceptar)
        
        let accionCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alerta.addAction(accionCancelar)
        present(alerta, animated: true, completion: nil)
    }
    
    //Guardar
    func guardarContacto(){
        do {
            try contexto.save()
            print("Se guardo correctamente")
        } catch let error as NSError {
            print("Error al guardar: \(error.localizedDescription)")
        }
    }
    
    //Leer
    func cargarCoreData(){
        let fetchRequest: NSFetchRequest<Contacto> = Contacto.fetchRequest()
        do {
            contactos = try contexto.fetch(fetchRequest)
        } catch {
            print("Error al cargar datos de coredata \(error.localizedDescription)")
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaContactos.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactoTableViewCell
        celda.nombreLabel.text = contactos[indexPath.row].nombre
        celda.telefonoLabel.text = "📞 \(contactos[indexPath.row].telefono ?? 0000)"
        celda.correoLabel.text = contactos[indexPath.row].correo
        celda.contactoImagen.image = UIImage(data: contactos[indexPath.row].imagen!)
        return celda
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tablaContactos.deselectRow(at: indexPath, animated: true)
        nombreEnviar = contactos[indexPath.row].nombre
        telefonoEnviar = contactos[indexPath.row].telefono
        direccionEnviar = contactos[indexPath.row].direccion
        correoEnviar = contactos[indexPath.row].correo
        
        indice = indexPath.row
        
        performSegue(withIdentifier: "editarContacto", sender: self)
    }
    
    //Metodos SwipeActions
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionBorrar = UIContextualAction(style: .normal, title: "") { (_, _ , _) in
            print("Borrar")
            //eliminar de coredata
            self.contexto.delete(self.contactos[indexPath.row])
            //eliminar de la UI
            self.contactos.remove(at: indexPath.row)
            self.guardarContacto()
            self.tablaContactos.reloadData()
        }
        accionBorrar.image = UIImage(named: "borrar.png")
        accionBorrar.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [accionBorrar])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionLLamada = UIContextualAction(style: .normal, title: "") { (_,_,_) in
            print("Realizar llamada")
        }
        accionLLamada.image = UIImage(named: "llamada.png")
        accionLLamada.backgroundColor = .blue
        
        let accionMensaje = UIContextualAction(style: .normal, title: "") { (_,_,_) in
            print("Mandar Correo")
        }
        
        accionMensaje.image = UIImage(named: "mensaje.png")
        accionMensaje.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [accionLLamada,accionMensaje])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarContacto" {
            let objEditar = segue.destination as! EditarViewController
            objEditar.recibirNombre = nombreEnviar
            objEditar.recibirTelefono = telefonoEnviar
            objEditar.recibirDireccion = direccionEnviar
            objEditar.recibirCorreo = correoEnviar
            objEditar.recibirIndice = indice
        }
    }
}
