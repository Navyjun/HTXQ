//
//  HTDisRecommenCell.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/30.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit

class HTDisRecommenCell: HTBaseCollectionViewCell {

    var dataItem: DiscoveryItem?
    let imgV = UIImageView()
    
    override func setupUI() {
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        addSubview(imgV)
        imgV.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
    }
    
    func refreshData(_ item:DiscoveryItem) {
        dataItem = item
        imgV.setImageWith(URL.init(string: item.imgUrl), placeholder: UIImage.init(named: kPlaceholder), options: .setImageWithFadeAnimation, completion: nil)
    }

}
