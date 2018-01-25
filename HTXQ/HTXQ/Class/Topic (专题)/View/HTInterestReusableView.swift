//
//  HTInterestReusableView.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/25.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit

class HTInterestReusableView: HTBaseCollectionReusableView {
    public lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.init(hexString: "333333")
        lb.font = UIFont.boldSystemFont(ofSize: 17.0)
        return lb
    }()
    
    override func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15.0)
            $0.top.equalToSuperview().offset(20.0)
            $0.right.equalToSuperview().offset(-15.0)
        }
    }
}
