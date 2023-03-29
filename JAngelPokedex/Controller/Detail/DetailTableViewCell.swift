//
//  DetailTableViewCell.swift
//  JAngelPokedex
//
//  Created by MacBookMBA6 on 28/03/23.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var namestatelbl: UILabel!
    @IBOutlet weak var baseStatelbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
