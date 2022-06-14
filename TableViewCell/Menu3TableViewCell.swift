//
//  Menu3TableViewCell.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/6/9.
//

import UIKit

class Menu3TableViewCell: UITableViewCell {
    
    @IBOutlet weak var drinkImageView: UIImageView!
    
    @IBOutlet weak var drinkNameLabel: UILabel!
    
    @IBOutlet weak var mediumPriceLabel: UILabel!
    
    @IBOutlet weak var lagerPriceLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
