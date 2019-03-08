//
//  UserOrderHistoryCell.swift
//  BakeryOrder
//
//  Created by JaonMicle on 01/09/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit

class UserOrderHistoryCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderIcon: UIImageView!
    @IBOutlet weak var orderStatusIcon: UIImageView!
    @IBOutlet weak var price: UILabel!
    
    private var order: Order = Order(){
        didSet{
            self.date.text = AppCommon.convertNiltoEmpty(string: self.order.order_date, defaultstr: "")
            self.address.text = AppCommon.convertNiltoEmpty(string: self.order.delivery_address, defaultstr: "")
            self.phone.text = AppCommon.convertNiltoEmpty(string: self.order.contact_phone, defaultstr: "")
            if order.driver != nil{
                self.driverName.text = AppCommon.convertNiltoEmpty(string: self.order.driver.name, defaultstr: "")
            }
            
            self.price.text = "\(String(self.order.total_price)) \(Constant.CURRENCY_UNIT)"
            self.orderNumber.text = AppCommon.convertNiltoEmpty(string: self.order.order_Id, defaultstr: "")
            if self.order.status == "created" || self.order.status == "awarded"{
                self.orderStatus.text = NSLocalizedString("Ordered", comment: "")
                self.orderIcon.image = #imageLiteral(resourceName: "historyicon-green")
                if AppCommon.instance.currentPayment != nil{
                    if self.order.paysel_flag{
                        self.orderIcon.image = #imageLiteral(resourceName: "checkicon-green")
                    }else{
                        self.orderIcon.image = #imageLiteral(resourceName: "uncheckicon-green")
                    }
                }
                self.orderStatusIcon.image = #imageLiteral(resourceName: "ordericon-green")
            }else if self.order.status == "started" || self.order.status == "ready" || self.order.status == "accepted"{
                self.orderStatus.text = NSLocalizedString("Making", comment: "")
                self.orderIcon.image = #imageLiteral(resourceName: "historyicon-green")
                if AppCommon.instance.currentPayment != nil{
                    if self.order.paysel_flag{
                        self.orderIcon.image = #imageLiteral(resourceName: "checkicon-green")
                    }else{
                        self.orderIcon.image = #imageLiteral(resourceName: "uncheckicon-green")
                    }
                }
                self.orderStatusIcon.image = #imageLiteral(resourceName: "bakeryplaceholdericon")
            }else if self.order.status == "delivery"{
                self.orderStatus.text = NSLocalizedString("Delivering", comment: "")
                self.orderIcon.image = #imageLiteral(resourceName: "historyicon-green")
                if AppCommon.instance.currentPayment != nil{
                    if self.order.paysel_flag{
                        self.orderIcon.image = #imageLiteral(resourceName: "checkicon-green")
                    }else{
                        self.orderIcon.image = #imageLiteral(resourceName: "uncheckicon-green")
                    }
                }
                self.orderStatusIcon.image = #imageLiteral(resourceName: "deliveryicon-green")
            }else if self.order.status == "completed"{
                self.orderStatus.text = NSLocalizedString("Completed", comment: "")
                self.orderIcon.image = #imageLiteral(resourceName: "historyicon-gray")
                self.orderStatusIcon.image = #imageLiteral(resourceName: "dollericon-gray")
            }else if self.order.status == "canceled"{
                self.orderIcon.image = #imageLiteral(resourceName: "historyicon-gray")
                self.orderStatus.text = NSLocalizedString("Canceled", comment: "")
                self.orderStatusIcon.image = #imageLiteral(resourceName: "closebtn")
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
    
    public func setData(order: Order){
        self.order = order;
    }

}
