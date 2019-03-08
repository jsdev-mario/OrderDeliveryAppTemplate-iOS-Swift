
//  EvalutionTableViewCell.swift
//  BakeryOrder
//
//  Created by JaonMicle on 03/09/2017.
//  Copyright © 2017 JaonMicle. All rights reserved.
//

import UIKit

class EvalutionCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bread_desription: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var unlikeBtn: UIButton!
    @IBOutlet weak var unlikeCount: UILabel!
    @IBOutlet weak var unlikeIcon: UIImageView!
    
    
    private var evaluation: Evaluation = Evaluation(){
        didSet{
            if self.evaluation.bread != nil{
                self.name.text = AppCommon.convertNiltoEmpty(string: self.evaluation.bread.name, defaultstr: "")
                self.bread_desription.text = AppCommon.convertNiltoEmpty(string: self.evaluation.bread.description, defaultstr: "")
                if self.evaluation.like == 1{
                    self.likeCount.text = String(self.evaluation.bread.like_count)
                    self.likeBtn.isUserInteractionEnabled = false;
                    self.likeIcon.image = #imageLiteral(resourceName: "likeicon-gray")
                    
                    self.unlikeCount.text = String(self.evaluation.bread.unlike_count)
                    self.unlikeBtn.isUserInteractionEnabled = true;
                    self.unlikeIcon.image = #imageLiteral(resourceName: "unlikeicon-green")
                }else if self.evaluation.like == -1{
                    self.likeCount.text = String(self.evaluation.bread.like_count)
                    self.likeBtn.isUserInteractionEnabled = true;
                    self.likeIcon.image = #imageLiteral(resourceName: "likeicon-green")
                    
                    self.unlikeCount.text = String(self.evaluation.bread.unlike_count)
                    self.unlikeBtn.isUserInteractionEnabled = false;
                    self.unlikeIcon.image = #imageLiteral(resourceName: "unlikeicon-gray")
                }else{
                    self.likeCount.text = String(self.evaluation.bread.like_count)
                    self.likeBtn.isUserInteractionEnabled = true;
                    self.likeIcon.image = #imageLiteral(resourceName: "likeicon-green")
                    
                    self.unlikeCount.text = String(self.evaluation.bread.unlike_count)
                    self.unlikeBtn.isUserInteractionEnabled = true;
                    self.unlikeIcon.image = #imageLiteral(resourceName: "unlikeicon-green")
                }
                
                if self.evaluation.bread.photo != nil{
                    if let url = URL(string: self.evaluation.bread.photo){
                        self.photo.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "breadplaceholder"))
                    }
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setData(evaluation: Evaluation){
        self.evaluation = evaluation;
    }

}
