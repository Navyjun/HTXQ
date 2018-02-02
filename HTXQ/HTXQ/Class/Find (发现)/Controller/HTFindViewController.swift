//
//  HTFindViewController.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/22.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit

class HTFindViewController: HTPageViewController {

    let segmentWidth:CGFloat = 180.0
    let segmentHeight:CGFloat = 44.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segment.frame = CGRect.init(x: 0, y: 0, width: segmentWidth, height: segmentHeight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
