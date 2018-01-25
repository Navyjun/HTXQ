//
//  HTBaseCollectionReusableView.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/25.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit

class HTBaseCollectionReusableView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupUI() {}
}
