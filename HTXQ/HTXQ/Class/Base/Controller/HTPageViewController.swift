//
//  HTPageViewController.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/22.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit
import HMSegmentedControl
import SnapKit

enum HTPageStyle {
    case navigationBarStyle
    case topBarStyle
}

class HTPageViewController: HTBaseViewController {
    
    lazy var segment:HMSegmentedControl = {
        let st = HMSegmentedControl()
        st.indexChangeBlock = { (index:Int) in
            if self.selectedIndex != index {
                let vcs = [self.viewControllers[index]]
                let direction:UIPageViewControllerNavigationDirection = self.selectedIndex > index ? .reverse : .forward
                self.pageController.setViewControllers(vcs, direction: direction, animated: false, completion: nil)
                self.selectedIndex = index
            }
        }
        return st
    }()
    
    lazy var pageController:UIPageViewController = {
        let pc = UIPageViewController.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pc.dataSource = self
        pc.delegate = self
        return pc
    }()
    
    var viewControllers : [UIViewController]!
    var titles          : [String]!
    var selectedIndex   = 0
    var pageStyle       : HTPageStyle!
    
    
    convenience init(vcs:[UIViewController], titles:[String], style:HTPageStyle) {
        self.init()
        self.viewControllers = vcs
        self.titles = titles
        self.pageStyle = style
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func setupUI() {
        guard viewControllers!.count > 0 else {
            return
        }
        
        pageController.setViewControllers([viewControllers[0]], direction: .forward, animated: false, completion: nil)
        addChildViewController(pageController)
        view.addSubview(pageController.view)
        
        switch pageStyle {
        case .navigationBarStyle:
            segment.backgroundColor = UIColor.clear
            segment.titleTextAttributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor:UIColor.init(hexString: "999999")!]
            segment.selectedTitleTextAttributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor:UIColor.init(hexString: "333333")!]
            segment.selectionStyle = .textWidthStripe
            segment.selectionIndicatorLocation = .down
            segment.selectionIndicatorColor = UIColor.black
            segment.selectionIndicatorHeight = 2.0
            segment.frame = CGRect.init(x: 0.0, y: 0.0, width: Double(kScreenWidth), height: kNavBarH)
            navigationItem.titleView = segment
            pageController.view.snp.makeConstraints({
                $0.edges.equalToSuperview()
            })
            break
        default:
            break
        }
        
        if titles.count == 0 {
            return
        }
        segment.sectionTitles = titles
        segment.selectedSegmentIndex = selectedIndex
        
    }
   
}

extension HTPageViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.index(of: viewController) else { return nil }
        let beforeIndex = index - 1
        guard beforeIndex >= 0 else { return nil }
        return viewControllers[beforeIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.index(of: viewController) else {return nil}
        let afterIndex = index + 1
        guard afterIndex < viewControllers.count else {return nil}
        return viewControllers[afterIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.last, let index = viewControllers.index(of: viewController) else {
            return
        }
        selectedIndex = index
        segment.setSelectedSegmentIndex(UInt(selectedIndex), animated: true)
    }
}
