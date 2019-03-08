//
//  UserOrderBreadViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 28/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import Toaster
import Alamofire
import SwiftyJSON


class UserOrderBreadViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    fileprivate let cellId: String = "UserOrderBreadCell"
    fileprivate var breadDatas: [OrderItem] = [];
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var breadDataTable: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var orderCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil{
            menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 250;
        }
        AppCommon.instance.currentOrder = nil;
        self.initData();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.totalPrice.text = String(AppCommon.instance.getTotalPrice()) + " " + Constant.CURRENCY_UNIT;
        if AppCommon.instance.currentOrder == nil{
            for breadData in self.breadDatas{
                breadData.count = 0;
                breadData.sp_offer = false;
            }
        }
        self.getOrder();
        self.breadDataTable.reloadData();
    }
    
    public func initData(){
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.BREADLISTGET_URL, method: .post, parameters: [:], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        self.breadDatas = [];
                        AppCommon.instance.breadData = []
                        for breadData in jsonData["data"].arrayValue{
                            let bread = Bread(JSONString: breadData.rawString()!)
                            let orderItem: OrderItem = OrderItem();
                            orderItem.bread = bread;
                            orderItem.count = 0;
                            self.breadDatas.append(orderItem)
                            AppCommon.instance.breadData.append(orderItem.bread)
                        }
                        self.breadDataTable.reloadData();
                    }else{
                        Toast(text: NSLocalizedString("Server Connection Error.", comment: "")).show();
                    }
                    break;
                case .failure( _):
                    Toast(text: NSLocalizedString("Server Connection Error.", comment: "")).show();
                    break;
                }
            })
        })
    }
    
    
    @IBAction func orderAction(_ sender: UIButton) {
        self.getOrder();
        if AppCommon.instance.getTotalPrice() == 0.0{
            Toast(text: NSLocalizedString("Please order breads.", comment: "")).show();
            return;
        }
        let toVc: UserOrderViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.USERORDER_VC) as! UserOrderViewController
        toVc.setOrderData(order: AppCommon.instance.currentOrder)
        self.present(toVc, animated: true, completion: nil)
    }
    
    public func getOrder(){
        
        AppCommon.instance.currentOrder = Order();
        var count: Int = 0;
        for orderitem in self.breadDatas{
            if orderitem.count > 0{
                AppCommon.instance.currentOrder.order_item.append(orderitem);
                count += orderitem.count;
            }
        }
        self.orderCountLabel.text = String(count);
        AppCommon.instance.currentOrder.client = AppCommon.instance.user;
        AppCommon.instance.currentOrder.status = "crated";
        AppCommon.instance.currentOrder.contact_phone = AppCommon.instance.user.phone
        AppCommon.instance.currentOrder.delivery_address = AppCommon.instance.user.address
        AppCommon.instance.currentOrder.delivery_location = AppCommon.instance.user.location
    }
    
    public func minusAction(_ sender: UIButton){
        if breadDatas[sender.tag].count > 0{
            breadDatas[sender.tag].count -= 1;
            if breadDatas[sender.tag].count == 0{
                breadDatas[sender.tag].sp_offer = false;
            }
            self.getOrder();
            self.totalPrice.text = String(AppCommon.instance.getTotalPrice()) + " " + Constant.CURRENCY_UNIT;
            self.breadDataTable.reloadData();
        }
    }
    
    public func plusAction(_ sender: UIButton){
        breadDatas[sender.tag].count += 1;
        self.getOrder();
        self.totalPrice.text = String(AppCommon.instance.getTotalPrice()) + " " + Constant.CURRENCY_UNIT
        self.breadDataTable.reloadData();
    }
    
    public func spSelectAction(_ sender: UIButton){
        if breadDatas[sender.tag].count > 0{
            self.breadDatas[sender.tag].sp_offer = !self.breadDatas[sender.tag].sp_offer;
            self.getOrder();
            self.breadDataTable.reloadData();
        }else{
            Toast(text: NSLocalizedString("Please buy bread.", comment: "")).show();
        }
    }
}


extension UserOrderBreadViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.breadDatas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserOrderBreadCell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! UserOrderBreadCell
        cell.minusBtn.addTarget(self, action: #selector(minusAction(_:)), for: .touchUpInside)
        cell.plusBtn.addTarget(self, action: #selector(plusAction(_:)), for: .touchUpInside)
        cell.spBtn.addTarget(self, action: #selector(spSelectAction(_:)), for: .touchUpInside)
        cell.minusBtn.tag = indexPath.row
        cell.plusBtn.tag = indexPath.row;
        cell.spBtn.tag = indexPath.row;
        cell.setBread(breadData: self.breadDatas[indexPath.row]);
        return cell;
    }
    
}
