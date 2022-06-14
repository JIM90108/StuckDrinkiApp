//
//  OrderListTableViewCell.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/6/2.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var drinkImageView: UIImageView!
    
    @IBOutlet weak var ordererLabel: UILabel!
    
    @IBOutlet weak var drinkNameLabel: UILabel!
    
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    
    @IBOutlet weak var feedLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var totalDrinkCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
