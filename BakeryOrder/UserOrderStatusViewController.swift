//
//  UserOrderStatusViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 03/09/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit
import Toaster
import MessageUI

class UserOrderStatusViewController: UIViewController , MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var drivrName: UILabel!
    @IBOutlet weak var driverPhoto: ExtentionImageView!

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    private var driver: User! = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.driver != nil{
            self.drivrName.text = AppCommon.convertNiltoEmpty(string: self.driver.name, defaultstr: "")
            if self.driver.photo != nil{
                if let url = URL(string: self.driver.photo){
                    self.driverPhoto.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "profilemain"))
                }
            }
            
            //let camera = GMSCameraPosition.camera(withLatitude: -7.9293122, longitude: 112.5879156, zoom: 18.0)
            
            let camera = GMSCameraPosition.camera(withLatitude: Double(self.driver.location.components(separatedBy: ":")[0])!, longitude: Double(self.driver.location.components(separatedBy: ":")[1])!, zoom: 15.0)
            
            self.mapView.camera = camera
            self.mapView.settings.compassButton = true
            self.mapView.settings.zoomGestures = true
            //self.mapView.selecte = nil;
            let marker = GMSMarker()
            if self.driver.location != nil{
                marker.position = CLLocationCoordinate2DMake(Double(self.driver.location.components(separatedBy: ":")[0])!, Double(self.driver.location.components(separatedBy: ":")[1])!);
            }
            marker.title = AppCommon.convertNiltoEmpty(string: self.driver.name, defaultstr: NSLocalizedString("Driver", comment: ""))
            marker.icon = #imageLiteral(resourceName: "map_drivericon")
            marker.map = self.mapView
        }
    }
    
    public func setData(driver: User!){
        self.driver = driver;
//        self.driver = User();
//        self.driver.name = "Jaon Micle";
//        self.driver.location = "-7.9293122:112.5879156"
//        self.driver.phone = "123456789"
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss();
    }

    @IBAction func callAction(_ sender: UIButton) {
        if self.driver != nil{
            if self.driver.phone != nil{
                if let phoneCallURL = URL(string: "tel://\(self.driver.phone)") {
                    let application:UIApplication = UIApplication.shared
                    if (application.canOpenURL(phoneCallURL)) {
                        if #available(iOS 10.0, *) {
                            application.open(phoneCallURL, options: [:], completionHandler: nil)
                        } else {
                            Toast(text: "Please update iOS version").show();
                        }
                    }
                }else{
                    Toast(text: "Invalidate phone number.").show();
                }
            }else{
                Toast(text: "Driver hasn't phone number.").show();
            }
        }
    }
    
    @IBAction func smsAction(_ sender: UIButton) {
        if self.driver != nil{
            if self.driver.phone != nil{
                if (MFMessageComposeViewController.canSendText()) {
                    let controller = MFMessageComposeViewController()
                    controller.body = "Hello. How are u?"
                    controller.recipients = [self.driver.phone]
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true, completion: nil);
                }else{
                    Toast(text: "Invalidate phone number.").show();
                }
            }else{
                Toast(text: "Driver hasn't phone number.").show();
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss();
    }
    
}
