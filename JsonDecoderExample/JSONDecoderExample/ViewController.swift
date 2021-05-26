//
//  ViewController.swift
//  JSONDecoderExample
//
//  Created by marco rodriguez on 17/05/21.
// based on https://www.hackingwithswift.com/read/7/3/parsing-json-using-the-codable-protocol 

import UIKit

struct Petition: Codable {
    var title: String
    var body: String
    
}

struct Petitions: Codable {
    var results: [Petition]
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   var petitions = [Petition]()
    
    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
               
        // let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
           let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"

           if let url = URL(string: urlString) {
               if let data = try? Data(contentsOf: url) {
                   // we're OK to parse!
                parse(json: data)
               }
           }
        
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tabla.reloadData()
        }
    }

    //MARK:- Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        celda.textLabel?.text = petitions[indexPath.row].title
        celda.detailTextLabel?.text = petitions[indexPath.row].body
        return celda
    }

}

