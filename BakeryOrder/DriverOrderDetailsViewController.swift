//
//  DriverOrderDetailsViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 28/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import Toaster
import GoogleMaps
import GooglePlaces
import MessageUI
import APScheduledLocationManager
import Alamofire
import SwiftyJSON

class DriverOrderDetailsViewController: UIViewController{
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    public var order: Order!;
    
    
    
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var payStatus: UILabel!
    @IBOutlet weak var payIcon: UIImageView!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var clientPhoto: ExtentionImageView!
    @IBOutlet weak var mapView: GMSMapView!
    
    public var destination: CLLocation!;
    public var locationManager: APScheduledLocationManager! = nil;
    public var cameraFlag = true;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData();
    }
    
    public func initData(){
        if self.order != nil{
            self.orderId.text = AppCommon.convertNiltoEmpty(string: self.order.order_Id, defaultstr: "")
            self.totalPrice.text = "\(String(self.order.total_price)) \(Constant.CURRENCY_UNIT)";
            self.address.text = AppCommon.convertNiltoEmpty(string: self.order.delivery_address, defaultstr: "")
            self.clientName.text = AppCommon.convertNiltoEmpty(string: self.order.client.name, defaultstr: "")
            self.orderTime.text = AppCommon.instance.orderTimeType[self.order.time_type]
            self.phoneNumber.text = AppCommon.convertNiltoEmpty(string: self.order.contact_phone, defaultstr: "")
            if self.order.pay_status == nil{
                self.payStatus.text = NSLocalizedString("None", comment: "")
                self.payIcon.image = nil;
            }
            if self.order.client.photo != nil{
                if let url = URL(string: self.order.client.photo){
                    self.clientPhoto.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "profilemain"))
                }
            }
            
            //let camera = GMSCameraPosition.camera(withLatitude: -7.9293122, longitude: 112.5879156, zoom: 18.0)
            
            let camera = GMSCameraPosition.camera(withLatitude: Double(self.order.delivery_location.components(separatedBy: ":")[0])!, longitude: Double(self.order.delivery_location.components(separatedBy: ":")[1])!, zoom: 17.0)
            self.mapView.camera = camera
            self.mapView.settings.compassButton = true
            self.mapView.settings.zoomGestures = true
            if self.order.delivery_location != nil{
                self.destination = CLLocation(latitude: Double(order.delivery_location.components(separatedBy: ":")[0])!, longitude: Double(self.order.delivery_location.components(separatedBy: ":")[1])!)
                self.createMarker(titleMarker: NSLocalizedString("Customer", comment: ""), subtitle: AppCommon.convertNiltoEmpty(string: self.order.client.name, defaultstr: ""), iconMarker: #imageLiteral(resourceName: "map_customericon"), location: self.destination)
            }
            self.startUpdateData();
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.locationManager != nil{
            self.locationManager.stopUpdatingLocation();
        }
    }
    
    
    public func startUpdateData(){
        self.locationManager = APScheduledLocationManager(delegate: self);
        self.locationManager.requestAlwaysAuthorization();
        self.locationManager.startUpdatingLocation(interval: 3)
    }
    
    public func updateData(location: CLLocation){
        //let location: CLLocation! = CLLocation(latitude: 51.486504, longitude: -3.129123)
        self.createMarker(titleMarker: NSLocalizedString("My Location", comment: ""), subtitle: AppCommon.instance.user.name, iconMarker: #imageLiteral(resourceName: "map_drivericon"), location: location)
        let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 17.0)
        if self.destination != nil{
            self.createMarker(titleMarker: NSLocalizedString("Customer", comment: ""), subtitle: AppCommon.convertNiltoEmpty(string: self.order.client.name, defaultstr: ""), iconMarker: #imageLiteral(resourceName: "map_customericon"), location: self.destination)
            drawPath(startLocation: location, endLocation: self.destination)
        }
        if self.cameraFlag{
            self.mapView?.animate(to: camera)
            self.cameraFlag = false
        }
    }
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
            
            let json = JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            print(routes)
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.red
                polyline.map = self.mapView
            }
        }
    }
    
    func createMarker(titleMarker: String, subtitle: String!, iconMarker: UIImage, location: CLLocation) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        marker.title = titleMarker
        marker.snippet = subtitle
        marker.icon = iconMarker
        marker.map = mapView
    }
    
    @IBAction func orderItemsAction(_ sender: UIButton) {
        let toVc: OrderViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.ORDERVIEW_VC) as! OrderViewController;
        toVc.setOrder(order: self.order);
        self.present(toVc, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton){
        self.dismiss();
    }
    
    @IBAction func phoneNumberAction(_ sender: UIButton) {
        if let phoneCallURL = URL(string: "tel://\(self.phoneNumber.text!)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    Toast(text: NSLocalizedString("Please update iOS version.", comment: "")).show();
                }
            }
        }
    }
    
    @IBAction func smsAction(_ sender: UIButton) {
        if self.phoneNumber.text != ""{
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = NSLocalizedString("Hello. How are u?", comment: "")
                controller.recipients = [self.phoneNumber.text!]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil);
            }else{
                Toast(text: "Invalidate phone number.").show();
            }
        }else{
            Toast(text: NSLocalizedString("Driver hasn't phone number.", comment: "")).show();
        }
    }
}


extension DriverOrderDetailsViewController: MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss();
    }
}

extension DriverOrderDetailsViewController: APScheduledLocationManagerDelegate{
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil{
//            let location: CLLocation! = CLLocation(latitude: 51.486504, longitude: -3.128968)
//            updateData(location: location)
            updateData(location: locations.last!);
        }
    }
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didFailWithError error: Error) {
        print("Data update error.")
    }
    
    func scheduledLocationManager(_ manager: APScheduledLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationManager.requestAlwaysAuthorization();
    }
}

