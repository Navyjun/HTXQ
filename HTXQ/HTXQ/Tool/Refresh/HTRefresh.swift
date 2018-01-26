//
//  HTRefresh.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/26.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit
import MJRefresh

extension UIScrollView {
    var htHead: MJRefreshHeader {
        get { return mj_header }
        set { mj_header = newValue }
    }
    
    var htFoot: MJRefreshFooter {
        get { return mj_footer }
        set { mj_footer = newValue }
    }
}

class HTRefreshAutoHeader: MJRefreshHeader {}

class HTRefreshAutoFooter: MJRefreshAutoFooter {}
