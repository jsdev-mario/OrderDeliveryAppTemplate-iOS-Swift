//
//  BakeryOrderCell.swift
//  BakeryOrder
//
//  Created by JaonMicle on 28/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit

class BakeryOrderCell: UITableViewCell {
    
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var reportIcon: UIImageView!
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var acceptIcon: UIImageView!
    @IBOutlet weak var acceptLabel: UILabel!
    @IBOutlet weak var detailOrderBtn: UIButton!
    @IBOutlet weak var receiptTimeBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet weak var rejectIcon: UIImageView!
    @IBOutlet weak var rejectLabel: UILabel!
    
    
    
    private var order: Order = Order(){
        didSet{
            self.deliveryTime.text = AppCommon.instance.orderTimeType[order.time_type]
            self.orderNumber.text = AppCommon.convertNiltoEmpty(string: self.order.order_Id, defaultstr: "")
            if self.order.message != nil{
                self.receiptTimeBtn.setTitle(self.order.message, for: .normal)
            }
            if self.order.status == "awarded"{
                self.reportLabel.textColor = Constant.SECONDARY_COLOR;
                self.reportIcon.image = #imageLiteral(resourceName: "report-gray")
                self.acceptLabel.textColor = Constant.PRIMARY_COLOR;
                self.acceptIcon.image = #imageLiteral(resourceName: "likeicon-green")
                self.rejectLabel.textColor = Constant.PRIMARY_COLOR;
                self.rejectIcon.image = #imageLiteral(resourceName: "unlikeicon-green")
                self.acceptBtn.isUserInteractionEnabled = true;
                self.rejectBtn.isUserInteractionEnabled = true;
                self.receiptTimeBtn.isUserInteractionEnabled = true;
                self.reportBtn.isUserInteractionEnabled = false;
            }else{
                self.reportLabel.textColor = Constant.PRIMARY_COLOR;
                self.reportIcon.image = #imageLiteral(resourceName: "report-green")
                self.acceptLabel.textColor = Constant.SECONDARY_COLOR;
                self.acceptIcon.image = #imageLiteral(resourceName: "likeicon-gray")
                self.rejectLabel.textColor = Constant.SECONDARY_COLOR;
                self.rejectIcon.image = #imageLiteral(resourceName: "unlikeicon-gray")
                self.acceptBtn.isUserInteractionEnabled = false;
                self.rejectBtn.isUserInteractionEnabled = false;
                self.receiptTimeBtn.isUserInteractionEnabled = false;
                self.reportBtn.isUserInteractionEnabled = true;
            }
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setOrder(order: Order){
        self.order = order;
    }

}
