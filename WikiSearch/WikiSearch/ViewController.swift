//
//  ViewController.swift
//  WikiSearch
//
//  Created by Mac8 on 12/05/21.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var buscarTextField: UITextField!
    @IBOutlet weak var WebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let urlWikipedia = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Wikipedia-logo-v2-es.svg/1200px-Wikipedia-logo-v2-es.svg.png"){
            WebView.load(URLRequest(url: urlWikipedia))
        }
        
    }

    @IBAction func buscaPalabraButton(_ sender: UIButton) {
        buscarTextField.resignFirstResponder()
        guard let palabraABuscar = buscarTextField.text else { return }
        buscarWikipedia(palabras: palabraABuscar)
    }
    
    func buscarWikipedia(palabras: String){
        
        if let urlAPI = URL(string: "https://es.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&titles=\(palabras.replacingOccurrences(of: " ", with: "%20"))")
        {
            let peticion = URLRequest(url: urlAPI)
            
            let tarea = URLSession.shared.dataTask(with: peticion) { [self]
                (datos, respuesta, err) in
                if err != nil {
                    print(err?.localizedDescription)
                } else {
                    do {
                        let objJson = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        
                        let querySubJson = objJson["query"] as! [String: Any]
                        
                        let pagesSubJson = querySubJson["pages"] as! [String: Any]
                        
                        let pageId = pagesSubJson.keys
                      
                        if pageId.contains("-1") == true {
                            if let urlOOps = URL(string: "https://www.123dreamit.com/static/new_dream/img/no-resultados.png"){
                                DispatchQueue.main.async {
                                    WebView.load(URLRequest(url: urlOOps))
                                }
                        }
                        } else {
                            let llaveExtracto = pageId.first!
       
                            let idSubJson = pagesSubJson[llaveExtracto] as! [String: Any]
                            
                            let extracto = idSubJson["extract"] as? String
                               
                            
                               
                            //Imprimir en la Interfaz Grafica WebView
                            DispatchQueue.main.async {
                                self.WebView.loadHTMLString(extracto ?? "No se obtuvieron resultados", baseURL: nil)
                            }
                        }
                        
                    } catch {
                        print("Error al procesar el JSON\(err?.localizedDescription)")
                    }
                }
            }
            tarea.resume()
        }
        
        
        
    }

}

