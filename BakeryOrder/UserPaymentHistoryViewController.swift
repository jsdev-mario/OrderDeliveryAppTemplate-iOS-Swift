//
//  UserPaymentHistoryViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 07/09/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class UserPaymentHistoryViewController: UIViewController {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var payHistoryTable: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    public var payHistorys: [Payment] = []
    public var cellId:String = "UserPaymentHistoryCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil{
            self.menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        }
        self.initData();
    }
    
    public func initData(){
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.PAYHISTORYGET_URL, method: .post, parameters: [:], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        self.payHistorys = []
                        for orderHistoryData in jsonData["data"].arrayValue{
                            let payHistory: Payment = Payment(JSONString: orderHistoryData.rawString()!)!
                            self.payHistorys.append(payHistory)
                        }
                        self.payHistoryTable.reloadData();
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

}

extension UserPaymentHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.payHistorys.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserPaymentHistoryCell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! UserPaymentHistoryCell
        if self.payHistorys[indexPath.row].pay_date != nil{
            cell.pay_date.text = self.payHistorys[indexPath.row].pay_date.components(separatedBy: "T")[0] + " " + self.payHistorys[indexPath.row].pay_date.components(separatedBy: "T")[1].components(separatedBy: ".")[0]
        }
        cell.pay_price.text = String(self.payHistorys[indexPath.row].pay_price) + " " + Constant.CURRENCY_UNIT
        var orderNumberStr = "\(AppCommon.instance.convertOrder32ID(id: self.payHistorys[indexPath.row].pay_orderids[0]))"
        for i in 1 ..< self.payHistorys[indexPath.row].pay_orderids.count{
            orderNumberStr += ", \(AppCommon.instance.convertOrder32ID(id: self.payHistorys[indexPath.row].pay_orderids[i]))"
        }
        cell.order_numbers.text = orderNumberStr;
        return cell;
    }
}

