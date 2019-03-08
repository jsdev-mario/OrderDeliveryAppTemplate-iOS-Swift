//
//  UserOrderViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 28/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import MessageUI



class MenuViewController: UIViewController,  MFMailComposeViewControllerDelegate  {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    //private let currentSendEmail: String = "info@online-bakery.com"
    private let currentSendEmail: String = "info@online-bakery.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func profileAction(_ sender: UIButton){
        let toVc: ProfileSettingViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.PROFILE_VC) as! ProfileSettingViewController
        revealViewController().pushFrontViewController(toVc, animated: true)
    }
    
    @IBAction func orderAction(_ sender: UIButton){
        let toVc: UserOrderBreadViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.USERORDERBREAD_VC) as! UserOrderBreadViewController
        revealViewController().pushFrontViewController(toVc, animated: true)
    }
    
    @IBAction func historyAction(_ sender: UIButton){
        let toVc: UserOrderHistoryViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.HISTORY_VC) as! UserOrderHistoryViewController
        revealViewController().pushFrontViewController(toVc, animated: true)
    }
    
    @IBAction func paymentAction(_ sender: UIButton){
        let toVc: UserPaymentHistoryViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.PAYHISTORY_VC) as! UserPaymentHistoryViewController
        revealViewController().pushFrontViewController(toVc, animated: true)
    }
    
    @IBAction func evalutionAction(_ sender: UIButton){
        let toVc: UserEvalutionViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.EVALUTION_VC) as! UserEvalutionViewController
        revealViewController().pushFrontViewController(toVc, animated: true)
    }
    
    @IBAction func contactAction(_ sender: UIButton){
//        let toVc: UserContactUsViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.CONTACT_VC) as! UserContactUsViewController
//        revealViewController().pushFrontViewController(toVc, animated: true)
        self.sendEmail()
    }
    
    
    private func sendEmail()->Void{
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: false, completion: nil);
        }else{
            showMailError()
        }
    }
    //**************** email process *************//
    
    private func configureMailController()->MFMailComposeViewController{
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([self.currentSendEmail])
        mailComposerVC.setSubject(NSLocalizedString("Bakery Order", comment: ""))
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    private func showMailError(){
        let sendMailErrorAlert = UIAlertController(title: NSLocalizedString("Could not send email", comment: ""), message: NSLocalizedString("Your device could not send email", comment: ""), preferredStyle: .alert)
        let dismiss = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        controller.dismiss(animated: true, completion: nil)
    }
    
}
