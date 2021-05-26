//
//  NewsViewController.swift
//  JSONDecoderExample
//
//  Created by marco rodriguez on 17/05/21.
//

import UIKit

struct Noticias: Codable {
    var articles: [Noticia]
}

struct Noticia: Codable {
    var title: String
    var description: String?
}



class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var noticias = [Noticia]()
    

    @IBOutlet weak var tablaNews: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "https://newsapi.org/v2/top-headlines?apiKey=f0797ef3b62d4b90a400ed224e0f82b7&country=mx"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // we're OK to parse!
                print("Listo para llamar a parse!")
             parse(json: data)
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        print("Se llamo parse y creo decoder")
        if let jsonPeticion = try? decoder.decode(Noticias.self, from: json) {
            print("Json Petitions: \(jsonPeticion.articles.count)")
            noticias = jsonPeticion.articles
            print("news: \(noticias.count)")
            tablaNews.reloadData()
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaNews.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        celda.textLabel?.text = noticias[indexPath.row].title
        celda.detailTextLabel?.text =  noticias[indexPath.row].description
        return celda
    }

}
