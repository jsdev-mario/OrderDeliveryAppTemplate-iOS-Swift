//
//  DriverDeliveryListViewController.swift
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

class DriverDeliveryListViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBOutlet weak var deliveryListTable: UITableView!
    @IBOutlet weak var notiIconView: EffectView!
    
    public var orderDatas: [Order] = [];
    fileprivate let cellId: String = "DriverDeliveyCell"
    public var locationManager: APScheduledLocationManager! = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notiIconView.isHidden = true;
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
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.DRIVERORDERSGET, method: .post, parameters: [:], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
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
                        self.startUpdateData()
                        DispatchQueue.main.async {
                            self.deliveryListTable.reloadData();
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
    
    @IBAction func resetPwdAction(_ sender: UIButton) {
        let alert = SCLAlertView()
        let oldPass = alert.addTextField(NSLocalizedString("current password.", comment: ""))
        let newPass = alert.addTextField(NSLocalizedString("new password.", comment: ""))
        let confirmPass = alert.addTextField(NSLocalizedString("confirm password.", comment: ""))
        alert.addButton(NSLocalizedString("Ok", comment: "")) {
            if oldPass.text == ""{
                Toast(text: NSLocalizedString("Please enter current password.", comment: "")).show();
                return;
            }
            if oldPass.text != AppCommon.instance.user.pass{
                Toast(text: NSLocalizedString("Invalidate current password.", comment: "")).show();
                return;
            }
            if newPass.text == ""{
                Toast(text: NSLocalizedString("Please enter new password.", comment: "")).show();
                return;
            }
            if confirmPass.text == ""{
                Toast(text: NSLocalizedString("Please confirm password.", comment: "")).show();
                return;
            }
            if newPass.text != confirmPass.text{
                Toast(text: NSLocalizedString("Don't match new password.", comment: "")).show();
                return;
            }
            self.setNewPassword(pass: newPass.text!);
        }
        alert.showEdit(NSLocalizedString("New Password", comment: ""), subTitle: NSLocalizedString("Please reset password.", comment: ""), closeButtonTitle: NSLocalizedString("Cancel", comment: ""), colorStyle: 0x78BE44)
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
            Alamofire.request(Constant.DRIVERORDERSGET, method: .post, parameters: [:], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
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
                            self.deliveryListTable.reloadData();
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
    
    public func startUpdateData(){
        self.locationManager = APScheduledLocationManager(delegate: self);
        self.locationManager.requestAlwaysAuthorization();
        self.locationManager.startUpdatingLocation(interval: 5)
    }
    
    public func updateData(location: String){
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
        
        Alamofire.request(Constant.PROFILESET_URL, method: .post, parameters: ["current_location": location], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
            switch response.result{
            case .success(let data):
                let jsonData = JSON(data);
                if jsonData["code"].intValue == 200{
                    
                }else{
                    print("send location error")
                }
                break;
            case .failure(let error):
                print(error.localizedDescription)
                break;
            }
        })
    }
    
    public func acceptAction(_ sender: UIButton){
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.DRIVERORDERACCEPT_URL, method: .post, parameters: ["_id": self.orderDatas[sender.tag].id], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        self.orderDatas[sender.tag].status = "accepted"
                        self.deliveryListTable.reloadData();
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
    
    public func deliveriedAction(_ sender: UIButton){
        if self.orderDatas[sender.tag].pay_status == nil{
            let alert = SCLAlertView()
            alert.addButton(NSLocalizedString("Ok", comment: "")) {
                self.deliveried(id: self.orderDatas[sender.tag].id)
            }
            if self.orderDatas[sender.tag].subscrib > 1{
                alert.showEdit(NSLocalizedString("Payment Confirm", comment: ""), subTitle: NSLocalizedString("Did you get cash for order?", comment: ""), closeButtonTitle: NSLocalizedString("Cancel", comment: ""), colorStyle: 0x78BE44)
            }else{
                alert.showEdit(NSLocalizedString("Payment Confirm", comment: ""), subTitle: NSLocalizedString("Did you get cash for order?", comment: ""), closeButtonTitle: NSLocalizedString("Cancel", comment: ""), colorStyle: 0x78BE44)
            }
        }else{
            self.deliveried(id: self.orderDatas[sender.tag].id)
        }
    }
    
    public func deliveried(id: Int){
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.DRIVERORDERCOMPLETED_URL, method: .post, parameters: ["_id": id], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        DispatchQueue.main.async {
                            self.notiIconView.isHidden = false;
                        }
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
    
    public func detailsAction(_ sender: UIButton){
        let toVc: DriverOrderDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.DRIVERORDERDETAILS_VC) as! DriverOrderDetailsViewController;
        toVc.order = self.orderDatas[sender.tag]
        self.present(toVc, animated: true, completion: nil)
    }
}


extension DriverDeliveryListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderDatas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DriverDeliveyCell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! DriverDeliveyCell
        cell.order = self.orderDatas[indexPath.row]
        cell.acceptBtn.addTarget(self, action: #selector(self.acceptAction(_:)), for: .touchUpInside)
        cell.deliveriedBtn.addTarget(self, action: #selector(self.deliveriedAction(_:)), for: .touchUpInside)
        cell.detailsBtn.addTarget(self, action: #selector(self.detailsAction(_:)), for: .touchUpInside)
        cell.acceptBtn.tag = indexPath.row;
        cell.deliveriedBtn.tag = indexPath.row;
        cell.detailsBtn.tag = indexPath.row;
        return cell;
    }
}

extension DriverDeliveryListViewController: APScheduledLocationManagerDelegate{
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("update");
        let location: String = "\(Double((locations.last?.coordinate.latitude)!)):\(Double((locations.last?.coordinate.longitude)!))"
        updateData(location: location);
    }
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didFailWithError error: Error) {
        print("Data update error.");
    }
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationManager.requestAlwaysAuthorization();
    }
}
