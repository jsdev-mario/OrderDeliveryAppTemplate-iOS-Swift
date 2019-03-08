//
//  RegisterViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 27/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import TextFieldEffects
import Toaster
import Alamofire
import SwiftyJSON
import SCLAlertView


class RegisterViewController: UIViewController {
    @IBOutlet weak var nameText: HoshiTextField!
    @IBOutlet weak var phoneText: HoshiTextField!
    @IBOutlet weak var passwordText: HoshiTextField!
    @IBOutlet weak var conPassText: HoshiTextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDismissKeyboard();
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss();
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        if self.nameText.text == ""{
            Toast(text: NSLocalizedString("Please enter username or email.", comment: "")).show();
            return;
        }
        
        if self.phoneText.text == ""{
            Toast(text: NSLocalizedString("Please enter phone number.", comment: "")).show();
            return;
        }
        
        if self.passwordText.text == ""{
            Toast(text: NSLocalizedString("Please enter password.", comment: "")).show();
            return;
        }
        
        if self.conPassText.text == ""{
            Toast(text: NSLocalizedString("Please confirm password.", comment: "")).show();
            return;
        }
        
        if self.conPassText.text != self.passwordText.text{
            Toast(text: NSLocalizedString("Don't match password.", comment: "")).show();
            return;
        }
        
        
        let param:[String: Any] = ["username": self.nameText.text!, "phone": self.phoneText.text!, "password": self.passwordText.text!, "user_type": "user"]
        
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.REG_URL, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        AppCommon.instance.user = User(JSONString: jsonData["data"].rawString()!)
                        self.go(to: Constant.VERIFICATION_VC, param: nil)
                    }else if jsonData["code"].intValue == 2{
                        Toast(text: NSLocalizedString("Account already exist.", comment: "")).show();
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
    }
    
    public func goHome(){
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
            }else if to == Constant.VERIFICATION_VC{
                let toVc: VerificationViewController = self.storyboard?.instantiateViewController(withIdentifier: to) as! VerificationViewController;
                self.present(toVc, animated: true, completion: nil)
            }
        }
    }
}

extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}



