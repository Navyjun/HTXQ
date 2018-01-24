//
//  HTTabBarController.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/22.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit
import YYKit

class HTTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageVC = HTTopicViewController.init(vcs: [HTInterestGroupVC(),
                                                     HTResearchSocietyVC()],
                                               titles: ["兴趣组","研究社"],
                                               style: .navigationBarStyle)

        addChildVC(pageVC,
                   "专题",
                   "tb_0")
        
        addChildVC(HTFindViewController(),
                   "发现",
                   "tb_10")
        
        addChildVC(HTFairViewController(),
                   "市集",
                   "tb_3")
        
        addChildVC(HTMeViewController(),
                   "我的",
                   "tb_4")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func addChildVC(_ viewCotroller:HTBaseViewController, _ title:String, _ imgStr:String) {
        
        viewCotroller.tabBarItem.title = title
        let normalAtt = [NSAttributedStringKey.foregroundColor:UIColor.init(red: 145.0/255.0, green: 145.0/255.0, blue: 145.0/255.0, alpha: 1)]
        let seleAtt = [NSAttributedStringKey.foregroundColor:UIColor.init(red: 69.0/255.0, green: 69.0/255.0, blue: 69.0/255.0, alpha: 1)]
        viewCotroller.tabBarItem.setTitleTextAttributes(normalAtt, for: .normal)
        viewCotroller.tabBarItem.setTitleTextAttributes(seleAtt, for: .selected)
        
        viewCotroller.tabBarItem.image = UIImage.init(named: imgStr)
        viewCotroller.tabBarItem.selectedImage = UIImage.init(named: imgStr+"_selected")
        
        let NavVC = HTNavigationController.init(rootViewController: viewCotroller)
        self.addChildViewController(NavVC)
    }

}
