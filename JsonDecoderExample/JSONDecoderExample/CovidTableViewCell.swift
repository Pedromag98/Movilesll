//
//  CovidTableViewCell.swift
//  JSONDecoderExample
//
//  Created by Mac8 on 25/05/21.
//

import UIKit

class CovidTableViewCell: UITableViewCell {

   
    
    @IBOutlet weak var paisLabel: UILabel!
    @IBOutlet weak var casosLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
