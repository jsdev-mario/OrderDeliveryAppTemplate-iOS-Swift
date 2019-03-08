//
//  UserPaymentHistoryCell.swift
//  BakeryOrder
//
//  Created by JaonMicle on 07/09/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit

class UserPaymentHistoryCell: UITableViewCell {

    @IBOutlet weak var pay_price: UILabel!
    @IBOutlet weak var pay_date: UILabel!
    @IBOutlet weak var order_numbers: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
