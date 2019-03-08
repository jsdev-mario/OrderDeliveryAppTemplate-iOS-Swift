//
//  UserOrderViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 28/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import Toaster
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import SCLAlertView
import Alamofire
import SwiftyJSON
import CoreLocation

class UserOrderViewController: UIViewController {

    @IBOutlet weak var userOrderTable: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var addressText: UILabel!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var checkOutBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkOutIcon: UIImageView!
    @IBOutlet weak var confirmDlg: DialogView!
    @IBOutlet weak var subscribeText: UITextField!
    @IBOutlet weak var orderlabel: UILabel!
    @IBOutlet weak var orderTackView: UIView!
    
    fileprivate var order: Order!;
    fileprivate var sp_offer: [SpecOffer] = []
    
    public var isOnlyDisplay: Bool = false;
    public var locationManager: CLLocationManager = CLLocationManager();
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    fileprivate let cellId1: String = "UserOrderCell"
    fileprivate let cellId2: String = "UserSpOrderCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData();
    }
    
    public func setOrderData(order: Order){
        self.order = order;
    }
    
    public func initData(){
        self.timeBtn.setTitle(AppCommon.instance.orderTimeType[self.order.time_type], for: .normal);
        self.addressText.text = AppCommon.convertNiltoEmpty(string: self.order.delivery_address, defaultstr: "")
        self.phoneText.text = AppCommon.convertNiltoEmpty(string: self.order.contact_phone, defaultstr: "")
        self.orderTackView.isHidden = true;
        if self.isOnlyDisplay{
            self.totalPrice.text = NSLocalizedString("Total Price: ", comment: "") + String(self.order.total_price) + " " + Constant.CURRENCY_UNIT
            self.titleLabel.text = AppCommon.convertNiltoEmpty(string: self.order.order_Id, defaultstr: "")
            self.orderlabel.text = NSLocalizedString("Reorder", comment: "")
            if self.order.status == "delivery"{
                self.orderTackView.isHidden = false;
            }
        }else{
            self.totalPrice.text = NSLocalizedString("Total Price: ", comment: "") + String(AppCommon.instance.getTotalPrice()) + " " + Constant.CURRENCY_UNIT
            self.orderlabel.text = NSLocalizedString("Order", comment: "")
        }
        
        for orderitem in self.order.order_item{
            if orderitem.sp_offer{
                let sp_offer: SpecOffer = SpecOffer();
                sp_offer.parent_id = orderitem.bread.id;
                sp_offer.bread = orderitem.bread.sp_bread;
                if sp_offer.bread == nil{
                    if orderitem.bread.sp_breadid != nil{
                        sp_offer.bread = AppCommon.instance.getBread(id: orderitem.bread.sp_breadid)
                    }else{
                        orderitem.sp_offer = false;
                        continue;
                    }
                }
                self.sp_offer.append(sp_offer)
            }
        }
    }
    
    @IBAction func confirmOkAction(_ sender: UIButton) {
        self.confirmDlg.hide();
        self.checkOut();
    }
    
    @IBAction func confirmCancelAction(_ sender: UIButton) {
        self.confirmDlg.hide();
    }
    
    @IBAction func subscribePlusAction(_ sender: UIButton) {
        var subscribeCount = Int(self.subscribeText.text!)!
        if subscribeCount < 30{
            subscribeCount += 1;
        }
        self.subscribeText.text = String(subscribeCount);
    }
    
    @IBAction func subscribeMinusAction(_ sender: UIButton) {
        var subscribeCount = Int(self.subscribeText.text!)!
        if subscribeCount > 1{
            subscribeCount -= 1;
        }
        self.subscribeText.text = String(subscribeCount);
    }
    
    @IBAction func orderTackingAction(_ sender: UIButton) {
        let toVc: UserOrderStatusViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.ORDERSTATUS_VC) as! UserOrderStatusViewController
        toVc.setData(driver: self.order.driver)
        self.present(toVc, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss();
    }
    
    @IBAction func checkOutAction(_ sender: UIButton) {
        if self.addressText.text == ""{
            Toast(text: NSLocalizedString("Please select delivery address", comment: "")).show();
            return;
        }
        if self.phoneText.text == ""{
            Toast(text: NSLocalizedString("Please enter contact phone number.", comment: "")).show();
            return;
        }
        self.confirmDlg.show();
    }
    
    public func checkOut(){
        var orderItemsParam: [[String: Any]] = []
        for orderItem in self.order.order_item{
            var orderItemParam: [String: Any] = [:]
            orderItemParam["bread"] = orderItem.bread.id
            orderItemParam["count"] = orderItem.count
            orderItemParam["sp_offer"] = orderItem.sp_offer
            orderItemsParam.append(orderItemParam)
        }
        let delivery_location = self.order.delivery_location == nil ? AppCommon.instance.user.location : self.order.delivery_location
        
        let param: [String: Any] = ["content": orderItemsParam, "time_type": self.order.time_type, "delivery_address": self.addressText.text!, "contact_phone": self.phoneText.text!, "delivery_location": delivery_location!, "subscrib": Int(self.subscribeText.text!)!]
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.ORDER_URL, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        let newOrder: Order = Order(JSONString: jsonData["data"].rawString()!)!
                        self.order.id = newOrder.id;
                        if self.order.id == nil{
                            Toast(text: NSLocalizedString("Invalidate Order", comment: "")).show();
                            return
                        }
                        AppCommon.instance.currentOrder = nil;
                        DispatchQueue.main.async {
                            self.dismiss();
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
    
    @IBAction func timeAction(_ sender: UIButton) {
        let alertSheet = UIAlertController(title: NSLocalizedString("Delivery Time", comment: ""), message: nil, preferredStyle: .actionSheet)
        let type1 = UIAlertAction(title: AppCommon.instance.orderTimeType[0], style: .default) { (type1) in
            self.timeBtn.setTitle(AppCommon.instance.orderTimeType[0], for: .normal)
            self.order.time_type = 0;
        }
        let type2 = UIAlertAction(title: AppCommon.instance.orderTimeType[1], style: .default) { (type2) in
            self.timeBtn.setTitle(AppCommon.instance.orderTimeType[1], for: .normal)
            self.order.time_type = 1;
        }
        let type3 = UIAlertAction(title: AppCommon.instance.orderTimeType[2], style: .default) { (type3) in
            self.timeBtn.setTitle(AppCommon.instance.orderTimeType[2], for: .normal)
            self.order.time_type = 2;
        }
        alertSheet.addAction(type1)
        alertSheet.addAction(type2)
        alertSheet.addAction(type3)
        self.present(alertSheet, animated: true, completion: nil)
    }
    
    @IBAction func addressAction(_ sender: UIButton) {
        self.locationManager.delegate = self;
        self.locationManager.requestAlwaysAuthorization();
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation();
    }
    
    public func viewGmsPlaceViewer(location: CLLocation!){
        var viewport: GMSCoordinateBounds! = nil
        if location != nil{
            let center = location.coordinate;
            let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001,
                                                   longitude: center.longitude + 0.001)
            let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001,
                                                   longitude: center.longitude - 0.001)
            viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        }
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self;
        present(placePicker, animated: true, completion: nil)
    }
    
    public func minusAction(_ sender: UIButton){
        if sender.tag < self.order.order_item.count{
            AppCommon.instance.minusOrderItem(orderitem: self.order.order_item[sender.tag])
            self.order.total_price = AppCommon.instance.getTotalPrice();
            self.totalPrice.text = NSLocalizedString("Total Price: ", comment: "") + String(self.order.total_price) + " " + Constant.CURRENCY_UNIT
        }else{
            for orderitem in self.order.order_item{
                if orderitem.bread.id == self.sp_offer[sender.tag - self.order.order_item.count].parent_id{
                    orderitem.sp_offer = false;
                    self.sp_offer.remove(at: sender.tag - self.order.order_item.count)
                }
            }
        }
        self.userOrderTable.reloadData();
    }
}


extension UserOrderViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.sp_offer.count > 0{
            return 2;
        }else{
            return 1;
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            let sectionView: UIView = UIView();
            sectionView.backgroundColor = Constant.PRIMARY_COLOR
            let contentRect: CGRect = CGRect(x:20, y:0, width: 150, height: 70);
            let headerLabel: UILabel = UILabel(frame: contentRect);
            headerLabel.text = "SPECIAL OFFER"
            headerLabel.textColor = UIColor.white;
            sectionView.addSubview(headerLabel);
            return sectionView;
        }else{
            return nil;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.order.order_item.count;
        }else{
            return self.sp_offer.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell: UserOrderCell = tableView.dequeueReusableCell(withIdentifier: self.cellId1, for: indexPath) as! UserOrderCell
            cell.minusBtn.addTarget(self, action: #selector(self.minusAction(_:)), for: .touchUpInside)
            cell.minusBtn.tag = indexPath.row;
            cell.minusBtn.isUserInteractionEnabled = !self.isOnlyDisplay;
            cell.setData(orderitem: self.order.order_item[indexPath.row]);
            return cell;
        }else{
            let cell: UserSpOrderCell = tableView.dequeueReusableCell(withIdentifier: self.cellId2, for: indexPath) as! UserSpOrderCell
            cell.minusBtn.addTarget(self, action: #selector(self.minusAction(_:)), for: .touchUpInside)
            cell.minusBtn.tag = self.order.order_item.count + indexPath.row;
            cell.minusBtn.isUserInteractionEnabled = !self.isOnlyDisplay;
            cell.setData(spoffer: self.sp_offer[indexPath.row]);
            return cell;
        }
    }
}

extension UserOrderViewController: GMSPlacePickerViewControllerDelegate{
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        if place.formattedAddress == nil{
            let alert = SCLAlertView()
            let addressName = alert.addTextField(NSLocalizedString("Please enter address of selected place", comment: ""))
            alert.addButton(NSLocalizedString("Ok", comment: "")) {
                self.addressText.text = addressName.text
            }
            alert.showEdit(NSLocalizedString("New Address", comment: ""), subTitle: NSLocalizedString("new address", comment: ""), closeButtonTitle: NSLocalizedString("Cancel", comment: ""), colorStyle: 0x78BE44)
        }else{
            self.addressText.text = place.formattedAddress!;
        }
        self.order.delivery_location = "\(place.coordinate.latitude):\(place.coordinate.longitude)"
        print(self.order.delivery_location)
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        print("No place selected")
    }
}

extension UserOrderViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.viewGmsPlaceViewer(location: locations.last);
        self.locationManager.stopUpdatingLocation();
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.viewGmsPlaceViewer(location: nil);
        self.locationManager.stopUpdatingLocation();
    }
}

public class SpecOffer{
    public var parent_id: Int!;
    public var bread: Bread!
}
