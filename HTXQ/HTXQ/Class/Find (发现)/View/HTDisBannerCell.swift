//
//  HTDisBannerCell.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/30.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit

class HTDisBannerCell: HTBaseCollectionViewCell {
    let bannerH: CGFloat = 175
    var dataItem: DiscoveryGroupItem?
    
    lazy var headView: ZCycleView = {
        let cv = ZCycleView()
        cv.timeInterval = 3
        cv.itemSize = CGSize(width: kScreenWidth, height: bannerH)
        cv.itemSpacing = 5
        cv.pageControlIndictirColor = UIColor.gray
        cv.pageControlCurrentIndictirColor = UIColor.white
        cv.pageControlAlignment = .right
        cv.placeholderImage = UIImage.init(named: kPlaceholder)
        return cv
    }()
    
    override func setupUI() {
        addSubview(headView)
        headView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
    }
    
    func refreshData(_ item:DiscoveryGroupItem)  {
        dataItem = item
        var imgstrs = [String]()
        for model in item.items {
            imgstrs.append(model.imageUrl)
        }
        headView.setUrlsGroup(imgstrs)
    }
    
    class func getCellHeight() -> CGFloat {
        return 175
    }
}
