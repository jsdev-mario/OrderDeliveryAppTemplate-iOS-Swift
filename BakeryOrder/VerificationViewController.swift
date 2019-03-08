//
//  VerificationViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 03/09/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import TextFieldEffects
import Toaster
class VerificationViewController: UIViewController {

    @IBOutlet weak var verificationText: HoshiTextField!
    
    @IBOutlet weak var phoneText: HoshiTextField!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendRequestCode(phone: "");
        self.setDismissKeyboard()
    }
    
    
    
    public func sendRequestCode(phone: String){
        
        var param: [String: Any] = [:]
        if phone != ""{
            param = ["phone": phone]
        }
        
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.VERIFICATION_URL, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
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
    
    
    @IBAction func backAction(_ sender: UIButton){
        self.dismiss()
    }
    
    @IBAction func requestAgain(_ sender: UIButton) {
        self.sendRequestCode(phone: self.phoneText.text!);
    }

    @IBAction func sendAction(_ sender: UIButton) {
        if self.verificationText.text == ""{
            Toast(text: NSLocalizedString("Please enter verification code", comment: "")).show()
            return;
        }
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.VERICONFIRM_URL, method: .post, parameters: ["code": self.verificationText.text!], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        self.goHome();
                    }else{
                        Toast(text: NSLocalizedString("Invalidate Code", comment: "")).show();
                    }
                    break;
                case .failure( _):
                    Toast(text: NSLocalizedString("Server Connection Error.", comment: "")).show();
                    break;
                }
            })
        })
    }
    
    public func goHome(){
        DispatchQueue.main.async {
            if AppCommon.instance.user != nil{
                if AppCommon.instance.user.user_type == "user"{
                    self.go(to: Constant.SWREVEAL_VC, param: nil)
                }else if AppCommon.instance.user.user_type == "bakery"{
                    self.go(to: Constant.BAKERYORDERLIST_VC, param: nil)
                }else if AppCommon.instance.user.user_type == "driver"{
                    self.go(to: Constant.DRIVERDELIVERYLIST_VC, param: nil)
                }
            }
        }
    }
    
    public func go(to: String, param: Any!){
        DispatchQueue.main.async {
            if to == Constant.REG_VC{
                let toVc: RegisterViewController = self.storyboard?.instantiateViewController(withIdentifier: to) as! RegisterViewController;
                self.present(toVc, animated: true, completion: nil)
            }else if to == Constant.SWREVEAL_VC{
                let toVc: SWRevealViewController = self.storyboard?.instantiateViewController(withIdentifier: to) as! SWRevealViewController;
                self.present(toVc, animated: true, completion: nil)
            }else if to == Constant.BAKERYORDERLIST_VC{
                let toVc: BakeryOrderListViewController = self.storyboard?.instantiateViewController(withIdentifier: to) as! BakeryOrderListViewController;
                self.present(toVc, animated: true, completion: nil)
            }else if to == Constant.DRIVERDELIVERYLIST_VC{
                let toVc: DriverDeliveryListViewController = self.storyboard?.instantiateViewController(withIdentifier: to) as! DriverDeliveryListViewController;
                self.present(toVc, animated: true, completion: nil)
            }
        }
    }


}
