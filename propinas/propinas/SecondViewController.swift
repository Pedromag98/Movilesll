//
//  SecondViewController.swift
//  propinas
//
//  Created by Mac8 on 23/03/21.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var propinaLabel: UILabel!
    
    var recibirCuenta: String?    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        propinaLabel.text = recibirCuenta
        
    }
    

}
