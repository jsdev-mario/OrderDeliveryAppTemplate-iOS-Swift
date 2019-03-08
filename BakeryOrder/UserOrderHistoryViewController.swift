//
//  OrderHistoryViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 31/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class UserOrderHistoryViewController: UIViewController {
    
    fileprivate var orderHistoryDatas: [Order] = []
    fileprivate var cloneDatas: [Order] = []
    fileprivate let cellId: String = "UserOrderHistoryCell"
    public var payPrice: Float = 0.0;
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var paymentMenuView: UIView!
    @IBOutlet weak var paytypeIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuicon: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil{
            self.menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 250;
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.initData();
    }
    
    public func initData(){
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.ORDERHISTORY_URL, method: .post, parameters: [:], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        self.orderHistoryDatas = []
                        for orderHistoryData in jsonData["data"].arrayValue{
                            let orderHistory: Order = Order(JSONString: orderHistoryData.rawString()!)!
                            self.orderHistoryDatas.append(orderHistory)
                        }
                        self.cloneDatas = self.orderHistoryDatas;
                        self.historyTable.reloadData();
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
        
        AppCommon.instance.currentPayment = nil;
        self.changeStatusUI()
    }
    
    @IBAction func paymentMenuAction(_ sender: UIButton){
        if AppCommon.instance.currentPayment == nil{
            AppCommon.instance.currentPayment = Payment();
            self.changeStatusUI();
        }else{
            var total_price: Float = 0.0
            var payOrders: [Int] = []
            for history in self.orderHistoryDatas{
                if history.paysel_flag{
                    total_price += history.total_price
                    payOrders.append(history.id)
                }
            }
            if total_price > 0{
                AppCommon.instance.currentPayment.pay_price = total_price
                AppCommon.instance.currentPayment.pay_orderids = payOrders;
                let toVc: UserPaymentViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.PAY_VC) as! UserPaymentViewController
                self.present(toVc, animated: true, completion: nil)
            }else{
                Toast(text: "Please select orders to pay").show();
            }
        }
    }
  
    
    public func changeStatusUI(){
        if AppCommon.instance.currentPayment != nil{
            self.orderHistoryDatas = [];
            for history in self.cloneDatas{
                if history.pay_status == nil{
                    history.paysel_flag = false;
                    orderHistoryDatas.append(history)
                }
            }
            self.paytypeIcon.image = #imageLiteral(resourceName: "confirmicon")
            self.titleLabel.text = "0.00 \(Constant.CURRENCY_UNIT)";
            self.menuBtn.removeTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.menuBtn.addTarget(self, action: #selector(self.paySelCancel(_:)), for: .touchUpInside);
            self.menuBtn.setTitle("Cancel", for: .normal)
            self.menuicon.image = nil
        }else{
            self.orderHistoryDatas = self.cloneDatas;
            self.titleLabel.text = NSLocalizedString("ORDER HISTORY", comment: "");
            if revealViewController() != nil{
                self.menuBtn.removeTarget(self, action: #selector(self.paySelCancel(_:)), for: .touchUpInside);
                self.menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
                revealViewController().rearViewRevealWidth = 250;
            }
            self.menuBtn.setTitle("", for: .normal)
            self.paytypeIcon.image = #imageLiteral(resourceName: "paymenticon")
            self.menuicon.image = #imageLiteral(resourceName: "menuicon")
            self.payPrice = 0.0;
        }
        self.historyTable.reloadData();
    }
    
    public func paySelCancel(_ sender: UIButton){
        AppCommon.instance.currentPayment = nil;
        self.changeStatusUI();
    }
}

extension UserOrderHistoryViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderHistoryDatas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserOrderHistoryCell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! UserOrderHistoryCell
        cell.setData(order: self.orderHistoryDatas[indexPath.row]);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if AppCommon.instance.currentPayment == nil{
            let toVc: UserOrderViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.USERORDER_VC) as! UserOrderViewController;
            toVc.isOnlyDisplay = true
            toVc.setOrderData(order: self.orderHistoryDatas[indexPath.row])
            self.present(toVc, animated: true, completion: nil)
        }else{
            if self.orderHistoryDatas[indexPath.row].paysel_flag{
                self.orderHistoryDatas[indexPath.row].paysel_flag = false;
                self.payPrice -= self.orderHistoryDatas[indexPath.row].total_price
            }else{
                self.orderHistoryDatas[indexPath.row].paysel_flag = true;
                self.payPrice += self.orderHistoryDatas[indexPath.row].total_price
            }
            self.titleLabel.text = "\(String(self.payPrice)) \(Constant.CURRENCY_UNIT)";
            self.historyTable.reloadData();
        }
    }
    
}

