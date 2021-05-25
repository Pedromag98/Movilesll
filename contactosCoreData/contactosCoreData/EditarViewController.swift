//
//  EditarViewController.swift
//  contactosCoreData
//
//  Created by Mac8 on 22/05/21.
//

import UIKit
import CoreData

class EditarViewController: UIViewController {
    
    var contactos = [Contacto]()
    
    //Conexion al contexto de la BD
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var recibirNombre: String?
    var recibirTelefono: Int64?
    var recibirDireccion: String?
    var recibirCorreo: String?
    var recibirIndice: Int?

    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!
    @IBOutlet weak var correoTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Indide: \(recibirIndice)")
        
        cargarCoreData()

        nombreTextField.text = recibirNombre
        telefonoTextField.text = "\(recibirTelefono!)"
        direccionTextField.text = recibirDireccion
        correoTextField.text = recibirCorreo
        imagenPerfil.image = UIImage(data: contactos[recibirIndice!].imagen!)
        
        
        //MARK:- Agregar gestura a la imagen
        let gestura = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestura.numberOfTapsRequired = 1
        gestura.numberOfTouchesRequired = 1
        //agregar la gestura a la imagen
        imagenPerfil.addGestureRecognizer(gestura)
        imagenPerfil.isUserInteractionEnabled = true
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

           self.view.endEditing(true)

       }
    @objc func clickImagen(gestura: UITapGestureRecognizer){
        print("Cambiar imagen")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
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
    
    @IBAction func tomarFotoButton(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func GuardarButton(_ sender: UIButton) {
        do {
            contactos[recibirIndice!].setValue(nombreTextField.text, forKey: "nombre")
            contactos[recibirIndice!].setValue(Int64(telefonoTextField.text!), forKey: "telefono")
            contactos[recibirIndice!].setValue(direccionTextField.text, forKey: "direccion")
            contactos[recibirIndice!].setValue(correoTextField.text, forKey: "correo")
            contactos[recibirIndice!].setValue(imagenPerfil.image?.pngData(), forKey: "imagen")
            
            try self.contexto.save()
            print("Se guardo correctamente")
        } catch {
            print("Error al actualizar \(error.localizedDescription)")
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func CancelarButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
//MARK:- Protocolo para la gestura de la imagen y seleccionar imagen
extension EditarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Que vamos a hacer cuando el usuario selecciona una imagen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagenSeleccionada = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imagenPerfil.image = imagenSeleccionada
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
