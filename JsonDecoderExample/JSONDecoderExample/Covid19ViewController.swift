////
//  NewsViewController.swift
//  JSONDecoderExample
//
//  Created by marco rodriguez on 17/05/21.
//

import UIKit

struct Covid: Codable {
    var country: String
    var cases: Int
}

class Covid19ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var covids = [Covid]()
    
    @IBOutlet weak var tablaCovid: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tablaCovid.register(UINib(nibName: "CovidTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        let urlString = "https://corona.lmao.ninja/v3/covid-19/countries"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // we're OK to parse!
             parse(json: data)
            }
        }

        
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        print("Se llamo parse y creo decoder")
        if let jsonPeticion = try? decoder.decode([Covid].self, from: json) {
            covids = jsonPeticion
            tablaCovid.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return covids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaCovid.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CovidTableViewCell
        celda.paisLabel?.text = covids[indexPath.row].country
        celda.casosLabel?.text = String(covids[indexPath.row].cases)
        return celda
    }

}
