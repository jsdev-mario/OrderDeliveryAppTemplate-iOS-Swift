//
//  BakeryOrderListViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 28/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import Toaster
import Alamofire
import SwiftyJSON
import SCLAlertView
import APScheduledLocationManager
import CoreLocation
import DateTimePicker


class BakeryOrderListViewController: UIViewController {
    
    @IBOutlet weak var bakeryOrderTable: UITableView!
    @IBOutlet weak var notiIconView: EffectView!
    
    fileprivate var orderDatas: [Order] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    fileprivate let cellId: String = "BakeryOrderCell"
    public var locationManager: APScheduledLocationManager! = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notiIconView.isHidden = true;
        self.initData();
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.locationManager != nil{
            self.locationManager.stopUpdatingLocation();
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.notiIconView.isHidden = true;
        self.initData()
    }
    
    public func initData(){
        if AppCommon.instance.user.bakey_id == nil{
            Toast(text: NSLocalizedString("Please login again.", comment: "")).show();
            return;
        }
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.BAKERYORDERSGET_URL, method: .post, parameters: [:], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        self.orderDatas = []
                        for orderData in jsonData["data"].arrayValue{
                            let order: Order = Order(JSONString: orderData.rawString()!)!
                            self.orderDatas.append(order)
                        }
                        self.startUpdateData();
                        DispatchQueue.main.async {
                            self.bakeryOrderTable.reloadData();
                        }
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
    
    public func updateOrders(orders: [Order]){
        if orders.count < self.orderDatas.count{
            var flag: Bool = false
            for i in 0 ..< self.orderDatas.count{
                for j in 0 ..< orders.count{
                    if self.orderDatas[i].id == orders[j].id{
                        flag = true;
                        break;
                    }
                }
                if !flag{
                    self.orderDatas.remove(at: i)
                }
            }
        }else{
            for order in orders{
                self.addOrder(order: order)
            }
        }
    }
    
    public func addOrder(order: Order){
        for bkorder in self.orderDatas{
            if bkorder.id == order.id{
                return;
            }
        }
        self.orderDatas.append(order)
    }
    
    public func startUpdateData(){
        self.locationManager = APScheduledLocationManager(delegate: self);
        self.locationManager.requestAlwaysAuthorization();
        self.locationManager.startUpdatingLocation(interval: 5)
    }
    
    public func updateData(){
        Alamofire.request(Constant.ORDERCOUNT_URL, method: .post, parameters: [:], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
            switch response.result{
            case .success(let data):
                let jsonData = JSON(data);
                if jsonData["code"].intValue == 200{
                    if self.orderDatas.count != jsonData["data"].intValue{
                        DispatchQueue.main.async {
                            self.notiIconView.isHidden = false
                        }
                    }
                }else{
                    print("get count error")
                }
                break;
            case .failure(let error):
                print(error.localizedDescription)
                break;
            }
        })
    }
    
    @IBAction func resetPwdAction(_ sender: UIButton) {
        let alert = SCLAlertView()
        let oldPass = alert.addTextField("current password.")
        let newPass = alert.addTextField("new password.")
        let confirmPass = alert.addTextField("confirm password.")
        alert.addButton("Ok") {
            if oldPass.text == ""{
                Toast(text: "Please enter current password.").show();
                return;
            }
            if oldPass.text != AppCommon.instance.user.pass{
                Toast(text: "Invalidate current password.").show();
                return;
            }
            if newPass.text == ""{
                Toast(text: "Please enter new password.").show();
                return;
            }
            if confirmPass.text == ""{
                Toast(text: "Please confirm password.").show();
                return;
            }
            if newPass.text != confirmPass.text{
                Toast(text: "don't match new password.").show();
                return;
            }
            self.setNewPassword(pass: newPass.text!);
        }
        alert.showEdit("New Password", subTitle: "Please reset password.", closeButtonTitle: "Cancel", colorStyle: 0x78BE44)
    }
    
    public func setNewPassword(pass: String){
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.CHANGEPASS_URL, method: .post, parameters: ["password": pass], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        Toast(text: NSLocalizedString("Success.", comment: "")).show();
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
    
    @IBAction func refreshAction(_ sender: UIButton) {
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.BAKERYORDERSGET_URL, method: .post, parameters: [:], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        self.orderDatas = []
                        for orderData in jsonData["data"].arrayValue{
                            let order: Order = Order(JSONString: orderData.rawString()!)!
                            self.orderDatas.append(order)
                        }
                        DispatchQueue.main.async {
                            self.notiIconView.isHidden = true;
                            self.bakeryOrderTable.reloadData();
                        }
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
    
    @IBAction func logOutAction(_ sender: UIButton) {
        self.dismiss();
    }
   
    
    public func reportAction(_ sender: UIButton){
        if orderDatas[sender.tag].status == "accepted"{
            let alert = SCLAlertView()
            alert.addButton(NSLocalizedString("Yes", comment: "")) {
                self.report(sender)
            }
            alert.showInfo(NSLocalizedString("Confirm", comment: ""), subTitle: NSLocalizedString("Are you sure?", comment: ""), closeButtonTitle: NSLocalizedString("No", comment: ""), colorStyle: 0x78BE44)
            return;
        }else{
            Toast(text: NSLocalizedString("Driver isn't allocated yet.", comment: "")).show();
        }
    }
    
    public func acceptAction(_ sender: UIButton){
        if self.orderDatas[sender.tag].message == nil{
            Toast(text: NSLocalizedString("please select time of receipt", comment: "")).show();
            return;
        }
        self.accept(sender)
    }
    
    public func rejectAction(_ sender: UIButton){
        let alert = SCLAlertView()
        let code = alert.addTextField(NSLocalizedString("Reason of reject.", comment: ""))
        alert.addButton(NSLocalizedString("Send", comment: "")) {
            if code.text == ""{
                Toast(text: NSLocalizedString("Please input reason of reject.", comment: "")).show();
                return;
            }
            self.reject(sender, reason: code.text!)
        }
        alert.showEdit(NSLocalizedString("Input", comment: ""), subTitle: NSLocalizedString("Reason of reject", comment: ""), closeButtonTitle: NSLocalizedString("Cancel", comment: ""), colorStyle: 0x78BE44)
    }
    
    public func selectTimeAction(_ sender: UIButton){
        let picker = DateTimePicker.show()
        picker.selectedDate = Date();
        picker.isDatePickerOnly = false;
        picker.highlightColor = Constant.PRIMARY_COLOR
        picker.doneButtonTitle = NSLocalizedString("SELECTE", comment: "")
        picker.setNeedsLayout();
        picker.completionHandler = { date in
            self.orderDatas[sender.tag].message = String(date: date, format: "yyyy-MM-dd HH:mm a")
            self.bakeryOrderTable.reloadData();
        }
    }
    
    public func detailsAction(_ sender: UIButton){
        let toVc: OrderViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.ORDERVIEW_VC) as! OrderViewController;
        toVc.setOrder(order: self.orderDatas[sender.tag]);
        self.present(toVc, animated: true, completion: nil)
        
    }
    
    public func report(_ sender: UIButton){
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.BAKERYORDERREPORT_URL, method: .post, parameters: ["_id": self.orderDatas[sender.tag].id], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        self.bakeryOrderTable.reloadData();
                        Toast(text: NSLocalizedString("Success.", comment: "")).show();
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
    
    public func accept(_ sender: UIButton){
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.BAKERYORDERSTART_URL, method: .post, parameters: ["_id": self.orderDatas[sender.tag].id, "message": self.orderDatas[sender.tag].message], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        self.orderDatas[sender.tag].status = "started"
                        self.bakeryOrderTable.reloadData();
                        Toast(text: NSLocalizedString("Success.", comment: "")).show();
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
    
    public func reject(_ sender: UIButton, reason: String){
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.BAKERYORDERREJECT_URL, method: .post, parameters: ["_id": self.orderDatas[sender.tag].id, "message": reason], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        self.removeOrderData(id: self.orderDatas[sender.tag].id)
                        self.bakeryOrderTable.reloadData();
                        Toast(text: NSLocalizedString("Success.", comment: "")).show();
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
    
    public func removeOrderData(id: Int){
        for i in 0 ..< self.orderDatas.count{
            if self.orderDatas[i].id == id{
                self.orderDatas.remove(at: i)
                return;
            }
        }
    }
}


extension BakeryOrderListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderDatas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BakeryOrderCell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! BakeryOrderCell
        cell.setOrder(order: self.orderDatas[indexPath.row])
        cell.reportBtn.addTarget(self, action: #selector(self.reportAction(_:)), for: .touchUpInside)
        cell.reportBtn.tag = indexPath.row;
        cell.acceptBtn.addTarget(self, action: #selector(self.acceptAction(_:)), for: .touchUpInside)
        cell.acceptBtn.tag = indexPath.row;
        cell.rejectBtn.addTarget(self, action: #selector(self.rejectAction(_:)), for: .touchUpInside)
        cell.rejectBtn.tag = indexPath.row;
        cell.receiptTimeBtn.addTarget(self, action: #selector(self.selectTimeAction(_:)), for: .touchUpInside)
        cell.receiptTimeBtn.tag = indexPath.row;
        cell.detailBtn.addTarget(self, action: #selector(self.detailsAction(_:)), for: .touchUpInside)
        cell.detailBtn.tag = indexPath.row;
        return cell;
    }
}

extension BakeryOrderListViewController: APScheduledLocationManagerDelegate{
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("UPDATE");
        updateData();
    }
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didFailWithError error: Error) {
        Toast(text: "Data update error.").show();
    }
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationManager.requestAlwaysAuthorization();
    }
}
