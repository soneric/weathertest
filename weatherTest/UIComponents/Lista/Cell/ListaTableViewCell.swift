//
//  ListaTableViewCell.swift
//  weatherTest
//
//  Created by entelgy on 25/04/19.
//  Copyright © 2019 ERIMIA. All rights reserved.
//

import UIKit

class ListaTableViewCell: UITableViewCell {

    @IBOutlet weak var estadoLabel: UILabel!
    @IBOutlet weak var ceuLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var distLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
