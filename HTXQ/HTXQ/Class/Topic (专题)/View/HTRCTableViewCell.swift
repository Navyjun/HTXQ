//
//  HTRCTableViewCell.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/29.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit

class HTRCTableViewCell: HTBaseTableViewCell {
    
    let imgH: CGFloat = 172.5
    var dataItem: RCPlateItem?
    
    let playImg = UIImageView.init(image: UIImage.init(named: "video-play"))
    lazy var imgView: UIView = {
        let ig = UIView()
        //ig.backgroundColor = UIColor.white
        ig.contentMode = .scaleAspectFill
        ig.clipsToBounds = true
        self.contentView.addSubview(ig)
        return ig
    }()
    
    lazy var titleL: UILabel = {
        return creationLable(textC: UIColor.black, font: 16.0)
    }()
    
    lazy var priceL: UILabel = {
        return creationLable(textC: UIColor.orange, font: 14.0)
    }()
    
    lazy var readCountL: UILabel = {
        return creationLable(textC: UIColor.init(hexString: "666666")!, font: 14.0)
    }()
    
    func creationLable(textC:UIColor, font:CGFloat) -> UILabel {
        let lb = UILabel()
        lb.textColor = textC
        lb.font = UIFont.systemFont(ofSize: font)
        self.contentView.addSubview(lb)
        return lb
    }

    override func setupUI() {
        self.backgroundColor = UIColor.clear
        imgView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(8)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(imgH)
        }
        
        titleL.snp.makeConstraints {
            $0.left.equalTo(imgView.snp.left)
            $0.right.equalTo(imgView.snp.right)
            $0.top.equalTo(imgView.snp.bottom).offset(15)
        }
        
        priceL.snp.makeConstraints {
            $0.left.equalTo(imgView.snp.left)
            $0.top.equalTo(titleL.snp.bottom).offset(10)
        }
        
        readCountL.snp.makeConstraints {
            $0.right.equalTo(imgView.snp.right)
            $0.centerY.equalTo(priceL.snp.centerY)
        }
        
        addSubview(playImg)
        playImg.snp.makeConstraints {
            $0.center.equalTo(imgView.snp.center)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray
        addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    public func refreshWithData(item :RCPlateItem)  {
        dataItem = item
        
        imgView.layer.setImageWith(URL.init(string: item.imgUrl), options: .setImageWithFadeAnimation)
        titleL.text = item.title
        priceL.text = "¥" + String.localizedStringWithFormat("%.2f", item.price)
        readCountL.text = "\(item.readCount)"+"人观看"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
