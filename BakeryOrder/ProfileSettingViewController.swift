//
//  ProfileSettingViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 28/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire
import SwiftyJSON
import Toaster
import SDWebImage
import ALCameraViewController
import SCLAlertView
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import DLRadioButton
import CoreLocation


class ProfileSettingViewController: UIViewController {
    
    @IBOutlet weak var nameText: HoshiTextField!
    @IBOutlet weak var emailText: HoshiTextField!
    @IBOutlet weak var addressText: HoshiTextField!
    @IBOutlet weak var phoneText: HoshiTextField!
    @IBOutlet weak var photoImage: ExtentionImageView!
    @IBOutlet weak var menuIcon: UIImageView!
   
    
    
    @IBOutlet weak var menuBtn: UIButton!
    private var progressHUD: MBProgressHUD!
    public var isDlgDisplay: Bool = false;
    private var tempPhoto: UIImage!
    public var locationManager: CLLocationManager!

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDismissKeyboard()
        if !self.isDlgDisplay{
            if revealViewController() != nil{
                menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
                revealViewController().rearViewRevealWidth = 250;
            }
        }else{
            self.menuIcon.image = #imageLiteral(resourceName: "backicon")
            self.menuBtn.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        }
        self.initData();
    }
    
    public func initData(){
        if AppCommon.instance.user != nil{
            self.nameText.text = AppCommon.convertNiltoEmpty(string: AppCommon.instance.user.name, defaultstr: "")
            self.emailText.text = AppCommon.convertNiltoEmpty(string: AppCommon.instance.user.email, defaultstr: "")
            self.phoneText.text = AppCommon.convertNiltoEmpty(string: AppCommon.instance.user.phone, defaultstr: "")
            self.addressText.text = AppCommon.convertNiltoEmpty(string: AppCommon.instance.user.address, defaultstr: "")
            if AppCommon.instance.user.photo != nil{
                if let url = URL(string: AppCommon.instance.user.photo){
                    self.photoImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "profilemain"))
                }
            }
        }
    }
    
    public func backAction(_ sender: UIButton){
        self.dismiss();
    }
    
    @IBAction func profileSave(_ sender: UIButton){
        if self.nameText.text! == ""{
            Toast(text: NSLocalizedString("Please enter name.", comment: "")).show();
            return;
        }
        
        let param: [String: Any] = ["username": self.nameText.text!, "email": self.emailText.text!, "address": self.addressText.text!, "phone": self.phoneText.text!, "current_location": AppCommon.instance.user.location]
        if self.photoImage.image == self.tempPhoto || self.tempPhoto == nil{
            AppCommon.startRunProcess(viewController: self, completion: {
                Alamofire.request(Constant.PROFILESET_URL, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
                    AppCommon.stopRunProcess();
                    switch response.result{
                    case .success(let data):
                        let jsonData = JSON(data);
                        if jsonData["code"].intValue == 200{
                            AppCommon.instance.user.address = self.addressText.text
                            AppCommon.instance.user.name = self.nameText.text;
                            AppCommon.instance.user.name = self.emailText.text
                            AppCommon.instance.user.phone = self.phoneText.text
                            Toast(text: NSLocalizedString("Success.", comment: "")).show();
                        }else{
                            Toast(text: NSLocalizedString("Server Connection Error.", comment: "")).show();
                        }
                        break;
                    case .failure( _):
                        Toast(text: NSLocalizedString("Server Connection Error.", comment: "")).show();
                        break;
                    }
                }
            })
        }else{
            AppCommon.startRunProcess(viewController: self, completion: {
                Alamofire.upload(multipartFormData: {(MultipartFormData) in
                    MultipartFormData.append(UIImageJPEGRepresentation(self.photoImage.image!, 0.1)!, withName: "photo", fileName: "profile_photo", mimeType: "image/jpg")
                    for (key, value) in param{
                        MultipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                    }
                }, to: Constant.PROFILESETWITHPHOTO_URL, encodingCompletion: {(result) in
                    switch result {
                    case .success(let upload, _, _):
                        upload.uploadProgress{(progress) in
                            print(progress);
                        }
                        upload.responseJSON {response in
                            AppCommon.stopRunProcess();
                            switch response.result{
                            case .success(let data):
                                let jsonData = JSON(data)
                                if jsonData["code"].intValue == 200{
                                    AppCommon.instance.user.address = self.addressText.text
                                    AppCommon.instance.user.name = self.nameText.text;
                                    AppCommon.instance.user.name = self.emailText.text
                                    AppCommon.instance.user.phone = self.phoneText.text
                                    if jsonData["data"].string != nil{
                                        if let url = URL(string: jsonData["data"].stringValue){
                                            self.photoImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "profilemain"))
                                            AppCommon.instance.user.photo = jsonData["data"].stringValue
                                        }
                                    }
                                    self.tempPhoto = self.photoImage.image;
                                    Toast(text: NSLocalizedString("Success.", comment: "")).show();
                                }else{
                                    Toast(text: NSLocalizedString("Server Connection Error.", comment: "")).show();
                                }
                                break;
                            case .failure( _):
                                Toast(text: NSLocalizedString("Server Connection Error.", comment: "")).show();
                                break;
                            }
                        }
                        break;
                    case .failure(let encodingError):
                        Toast(text: encodingError.localizedDescription).show();
                        break; 
                    }
                })
            })
        }
    }
    
    @IBAction func passwordResetAction(_ sender: UIButton) {
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
            Alamofire.request(Constant.CHANGEPASS_URL, method: .post, parameters: ["user_id": AppCommon.instance.user.id!,"password": pass], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess()
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        AppCommon.instance.user.pass = pass
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
    
    @IBAction func photoChangeAction(_ sender: UIButton) {
        self.tempPhoto = self.photoImage.image;
        let croppingEnabled = true
        let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled) { [weak self] image, asset in
            if image != nil{
                self?.photoImage.image = image;
            }
            self?.dismiss(animated: true, completion: nil)
        }
        present(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func addressSelectAction(_ sender: UIButton) {
        self.locationManager = CLLocationManager();
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
}

extension ProfileSettingViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}

extension ProfileSettingViewController: GMSPlacePickerViewControllerDelegate{
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        if place.formattedAddress == nil{
            let alert = SCLAlertView()
            let addressName = alert.addTextField(NSLocalizedString("Please enter address of selected place.", comment: ""))
            alert.addButton(NSLocalizedString("Ok", comment: "")) {
                self.addressText.text = addressName.text
            }
            alert.showEdit(NSLocalizedString("New Address", comment: ""), subTitle: NSLocalizedString("New Address", comment: ""), closeButtonTitle: NSLocalizedString("Cancel", comment: ""), colorStyle: 0x78BE44)
        }else{
            self.addressText.text = place.formattedAddress!;
        }
        AppCommon.instance.user.location = "\(place.coordinate.latitude):\(place.coordinate.longitude)"
        print(AppCommon.instance.user.location)
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
}

extension ProfileSettingViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.viewGmsPlaceViewer(location: locations.last);
        self.locationManager.stopUpdatingLocation();
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.viewGmsPlaceViewer(location: nil);
        self.locationManager.stopUpdatingLocation();
    }
}


