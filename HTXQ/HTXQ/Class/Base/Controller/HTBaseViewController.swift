//
//  HTBaseViewController.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/22.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit

class HTBaseViewController: UIViewController {
    
    lazy var fpsLabel :YYFPSLabel = {
        let fps = YYFPSLabel()
        return fps
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(hexString: "fafafa")
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    open func setupUI() {
    }

    func addFpsLabel()  {
        self.view.addSubview(fpsLabel)
        fpsLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-61)
        }
    }
}
