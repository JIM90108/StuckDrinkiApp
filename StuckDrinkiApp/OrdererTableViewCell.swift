//
//  OrdererTableViewCell.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/6/2.
//

import UIKit

class OrdererTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ordererLabel: UILabel!
    
    @IBOutlet weak var ordererTextField: UITextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
