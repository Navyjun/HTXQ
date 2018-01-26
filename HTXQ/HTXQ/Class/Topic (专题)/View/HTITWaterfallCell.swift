//
//  HTITWaterfallCell.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/26.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit
import SnapKit
import YYKit

class HTITWaterfallCell: HTBaseCollectionViewCell {
    let bottomH:CGFloat = 60
    let bottomView = UIView()
    let readImage = UIImageView.init(image: UIImage.init(named: "hp_count"))
    var dataItem :PlateViewsItem?
    
    
    lazy var imageView :UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        self.addSubview(iv)
        return iv
    }()
    
    lazy var titleLabel:UILabel = {
        return creationLable(textC: UIColor.black, font: 16.0)
    }()
    
    lazy var topLabel:UILabel = {
        return creationLable(textC: UIColor.init(hexString: "999999")!, font: 14.0)
    }()
    
    lazy var readCountLabel:UILabel = {
        return creationLable(textC: UIColor.init(hexString: "999999")!, font: 14.0)
    }()
    
    func creationLable(textC:UIColor, font:CGFloat) -> UILabel {
        let lb = UILabel()
        lb.textColor = textC
        lb.font = UIFont.systemFont(ofSize: font)
        bottomView.addSubview(lb)
        return lb
    }
    
    override func setupUI() {
        self.backgroundColor = UIColor.clear
        bottomView.backgroundColor = UIColor.white
        self.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(bottomH)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(6)
            $0.right.equalToSuperview().offset(-6)
            $0.top.equalTo(10)
        }
        
        topLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.left.equalTo(titleLabel.snp.left)
        }
        
        readCountLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-6)
            $0.centerY.equalTo(topLabel.snp.centerY)
        }
        
        bottomView.addSubview(readImage)
        readImage.snp.makeConstraints {
            $0.right.equalTo(readCountLabel.snp.left)
            $0.centerY.equalTo(readCountLabel.snp.centerY)
        }
        
        imageView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    public func refreshData(item:PlateViewsItem) {
        
        titleLabel.text = item.name ?? ""
        topLabel.text = item.cateName ?? ""
        readCountLabel.text = "\(item.readCount)"
        
        
        imageView.cancelCurrentImageRequest()
        imageView.setImageWith(URL.init(string: item.coverImg ?? ""), placeholder: UIImage.init(named: kPlaceholder), options: .avoidSetImage) { [weak self] (image, url, from, stage, error) in
            if image != nil {
                self!.imageView.image = image
            }
        }
    }
}
