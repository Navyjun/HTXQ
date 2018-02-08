//
//  HTDisBbsCell.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/31.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit
import YYKit

class HTDisBbsCell: UITableViewCell {
    
    let maxPicCount = 9
    let commMargin = 15.0
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var authorIcon: UIImageView!
    @IBOutlet weak var authorNameL: UILabel!
    @IBOutlet weak var authorSignLabel: UILabel!
    @IBOutlet weak var sendTimeLabel: UILabel!
    @IBOutlet weak var opationHandelView: UIView!
    
    var dataItem = DiscoveryBbsItem()

    lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var picsContentView : UIView = {
        let view = UIView()
        for i in 0..<maxPicCount {
            let picView = UIView()
            picView.backgroundColor = UIColor.clear
            picView.contentMode = .scaleToFill
            picView.clipsToBounds = true
            view.addSubview(picView)
        }
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(commMargin)
            $0.right.equalToSuperview().offset(-commMargin)
            $0.top.equalTo(headView.snp.bottom)
        }
        
        contentView.addSubview(picsContentView)
        picsContentView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(commMargin)
            $0.right.equalToSuperview().offset(-commMargin)
            $0.bottom.equalTo(opationHandelView.snp.top)
            $0.top.equalTo(contentLabel.snp.bottom)
        }
    }
    
    public func configCell(_ item:DiscoveryBbsItem) {
        dataItem = item
        authorIcon.setImageWith(URL.init(string: item.bbsAuthor.headImg),
                                placeholder: UIImage.init(named: kUserHeadPlaceholder),
                                options: .setImageWithFadeAnimation,
                                manager: BDHelper.avatarImageManager(),
                                progress: nil,
                                transform: nil,
                                completion: nil)
        
        authorNameL.text = item.bbsAuthor.userName
        authorSignLabel.text = item.bbsAuthor.signature
        sendTimeLabel.text = item.createDate
        contentLabel.text = item.content
        configPics()
    }
    
    func configPics()  {
      
        let picCount = dataItem.imgItemsArray.count
        if picCount == 0 {
            for view in picsContentView.subviews {
                view.isHidden = true
            }
            return
        }
        
        let picsCount = picsContentView.subviews.count
        
        for i in 0..<picsCount {
            let currentView = picsContentView.subviews[i]
            if i >= picCount{
                currentView.layer.cancelCurrentImageRequest()
                currentView.isHidden = true
            }else{
                let imgItem = dataItem.imgItemsArray[i]
                currentView.isHidden = false
                currentView.frame = imgItem.imgFrame
                currentView.layer.removeAllAnimations()
                currentView.layer.setImageWith(URL(string: imgItem.imgURL),
                                               placeholder: UIImage.init(color: UIColor.groupTableViewBackground),
                                               options: .avoidSetImage,
                                               completion: { (image, url, form, stage, error) in
                                                if image == nil {
                                                    return;
                                                }
                                                currentView.layer.contents = image?.cgImage
                                                if form != .memoryCacheFast {
                                                    let transition = CATransition()
                                                    transition.duration = 0.15
                                                    transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
                                                    transition.type = kCATransitionFade
                                                    currentView.layer.add(transition, forKey: "contents")
                                                }
                })
                
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
