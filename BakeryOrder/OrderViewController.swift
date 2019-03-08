//
//  BakeryOrderViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 06/09/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class OrderViewController: UIViewController {

    @IBOutlet weak var bakeryOrderViewTable: UITableView!
    
    @IBOutlet weak var orderNumber: UILabel!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    public var order: Order!
    public var orderItemsData: [OrderItem] = [];
    public var cellId: String = "BakeryOrderViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData();
    }
    
    public func initData(){
        if AppCommon.instance.breadData.count == 0{
            AppCommon.startRunProcess(viewController: self, completion: {
                Alamofire.request(Constant.BREADLISTGET_URL, method: .post, parameters: [:], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                    AppCommon.stopRunProcess();
                    switch response.result{
                    case .success(let data):
                        let jsonData = JSON(data);
                        if jsonData["code"].intValue == 200{
                            AppCommon.instance.breadData = []
                            for breadData in jsonData["data"].arrayValue{
                                let bread = Bread(JSONString: breadData.rawString()!)
                                AppCommon.instance.breadData.append(bread!)
                            }
                            self.orderItemsData = self.order.order_item
                            self.modifyOrderItems();
                            self.orderNumber.text = self.order.order_Id;
                            self.bakeryOrderViewTable.reloadData();
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
        }else{
            self.orderItemsData = self.order.order_item
            self.modifyOrderItems();
            self.orderNumber.text = order.order_Id;
            self.bakeryOrderViewTable.reloadData();
        }
    }
    
    public func modifyOrderItems(){
        for orderitem in self.order.order_item{
            if orderitem.sp_offer{
                if orderitem.bread.sp_bread != nil{
                    self.updateOrder(bread: orderitem.bread.sp_bread)
                }else{
                    if orderitem.bread.sp_breadid != nil{
                        self.updateOrder(bread: AppCommon.instance.getBread(id: orderitem.bread.sp_breadid))
                    }
                }
            }
        }
    }
    
    public func updateOrder(bread: Bread){
        for orderitem in self.orderItemsData{
            if orderitem.bread.id == bread.id{
                orderitem.count += 1
                return;
            }
        }
        let newOrderItem: OrderItem = OrderItem();
        newOrderItem.bread = bread;
        newOrderItem.count = 1;
        self.orderItemsData.append(newOrderItem)
    }
    
    @IBAction func backAction(_ sender: UIButton){
        self.dismiss();
    }
    
    public func setOrder(order: Order){
        self.order = order;
    }
}


extension OrderViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderItemsData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BakeryOrderViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! BakeryOrderViewCell
        cell.setData(orderitem: self.orderItemsData[indexPath.row])
        return cell;
    }
}
