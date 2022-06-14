//
//  OrderDrinkTableViewCell.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/6/2.
//

import UIKit

class OrderDrinkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addPriceLabel: UILabel!
    
    @IBOutlet weak var drinkMessageLabel: UILabel!
    
    
    @IBOutlet weak var optionBtnImageView: UIImageView!
    
    @IBOutlet weak var feedAddPriceLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
