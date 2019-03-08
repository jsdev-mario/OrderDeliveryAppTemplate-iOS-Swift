//
//  UserEvalutionViewController.swift
//  BakeryOrder
//
//  Created by JaonMicle on 31/08/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster
import ObjectMapper

class UserEvalutionViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    fileprivate var cellId: String = "EvalutionCell"
    fileprivate var evaluationData: [Evaluation] = []
    
    
    @IBOutlet weak var evalutionTable: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil{
            self.menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 250;
        }
        self.initData();
    }
    
    public func initData(){
        self.evaluationData = [];
        for bread in AppCommon.instance.breadData{
            var flag = false;
            for (key, value) in AppCommon.instance.user.evaluation{
                if key == "bread\(bread.id!)"{
                    self.evaluationData.append(Evaluation(bread: bread, like: value));
                    flag = true;
                }
            }
            if !flag{
                self.evaluationData.append(Evaluation(bread: bread, like: 0))
            }
        }
    }
    public func likeAction(_ sender: UIButton){
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.BREADLIKE_URL, method: .post, parameters: ["_id": self.evaluationData[sender.tag].bread.id], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        self.evaluationData[sender.tag].like = 1;
                        self.evaluationData[sender.tag].bread.like_count = (Bread(JSONString: jsonData["data"].rawString()!)?.like_count)!
                        self.evaluationData[sender.tag].bread.unlike_count = (Bread(JSONString: jsonData["data"].rawString()!)?.unlike_count)!
                        AppCommon.instance.user.evaluation["bread\(self.evaluationData[sender.tag].bread.id!)"] = 1
                        DispatchQueue.main.async {
                            self.evalutionTable.reloadData();
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
    
    public func unlikeAction(_ sender: UIButton){
        AppCommon.startRunProcess(viewController: self, completion: {
            Alamofire.request(Constant.BREADUNLIKE_URL, method: .post, parameters: ["_id": self.evaluationData[sender.tag].bread.id], encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                AppCommon.stopRunProcess();
                switch response.result{
                case .success(let data):
                    let jsonData = JSON(data);
                    if jsonData["code"].intValue == 200{
                        self.evaluationData[sender.tag].like = -1;
                        self.evaluationData[sender.tag].bread.like_count = (Bread(JSONString: jsonData["data"].rawString()!)?.like_count)!
                        self.evaluationData[sender.tag].bread.unlike_count = (Bread(JSONString: jsonData["data"].rawString()!)?.unlike_count)!
                        AppCommon.instance.user.evaluation["bread\(self.evaluationData[sender.tag].bread.id!)"] = -1
                        DispatchQueue.main.async {
                            self.evalutionTable.reloadData();
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
}

extension UserEvalutionViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.evaluationData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EvalutionCell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! EvalutionCell
        cell.setData(evaluation: self.evaluationData[indexPath.row]);
        cell.likeBtn.addTarget(self, action: #selector(self.likeAction(_ :)), for: .touchUpInside)
        cell.likeBtn.tag = indexPath.row;
        cell.unlikeBtn.addTarget(self, action: #selector(self.unlikeAction(_ :)), for: .touchUpInside)
        cell.unlikeBtn.tag = indexPath.row;
        return cell;
    }
}

