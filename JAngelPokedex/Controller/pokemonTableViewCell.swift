//
//  pokemonTableViewCell.swift
//  JAngelPokedex
//
//  Created by MacBookMBA6 on 27/03/23.
//

import UIKit

class pokemonTableViewCell: UITableViewCell {

    
    @IBOutlet weak var pokestackview: UIStackView!
    @IBOutlet weak var sprites: UIImageView!
    
    @IBOutlet weak var pokemonname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
