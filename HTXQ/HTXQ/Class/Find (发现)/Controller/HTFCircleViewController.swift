//
//  HTFCircleViewController.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/30.
//  Copyright © 2018年 baoqianli. All rights reserved.
//  圈子

import UIKit
import HMSegmentedControl

class HTFCircleViewController: HTBaseViewController {
    
    let circleListH: CGFloat = 45.0
    var circleItemArray = [DiscoveryCircleItem]()
    var selectedCircleItem = DiscoveryCircleItem()
    
    lazy var segment: HMSegmentedControl = {
        let st = HMSegmentedControl()
        st.backgroundColor = UIColor.white
        st.titleTextAttributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:UIColor.init(hexString: "999999")!]
        st.selectedTitleTextAttributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:HTColor(198, 176, 91, 1)]
        st.selectionIndicatorHeight = 0.0
        st.frame = CGRect.init(x: 0.0, y: kNavBarH, width: Double(kScreenWidth), height: Double(circleListH))
        st.indexChangeBlock = { [weak self] (index:Int) in
            if index < self!.circleItemArray.count {
                self!.selectedCircleItem.offsetY = self!.tableView.contentOffset.y
                self!.selectedCircleItem = self!.circleItemArray[index]
                self!.tableView.reloadData()
                if self!.selectedCircleItem.items.count == 0 {
                    self!.tableView.htFoot.isHidden = true
                    self!.loadBbsListByCircle(self!.selectedCircleItem,true)
                }else{
                    self!.view.layoutIfNeeded()
                    self!.tableView.setContentOffset(CGPoint.init(x: 0, y: self!.selectedCircleItem.offsetY), animated: false)
                }
            }
        }
        return st
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.delegate = self
        tb.register(UINib.init(nibName: "HTDisBbsCell", bundle: Bundle.main), forCellReuseIdentifier: "HTDisBbsCell")
        tb.htHead = HTRefreshAutoHeader { [weak self] in
            self!.loadBbsListByCircle(self!.selectedCircleItem, true)
        }
        tb.htFoot = HTRefreshAutoNormalFooter { [weak self] in
            self!.loadBbsListByCircle(self!.selectedCircleItem, false)
        }
        tb.htFoot.isHidden = true
        return tb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addFpsLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func setupUI() {
        view.addSubview(segment)
        loadCircleListData()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(segment.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
    }
    
    private func loadCircleListData() {
        ApiLoadingProvider.request(HTApi.getBbsCircleList(type: 1), model: DiscoveryCircleList.self) { [weak self] (model, error) in
            if error != nil || model == nil || model?.data == nil{
                return
            }
            
            var titleArray = [String]()
            for item in model!.data! {
                titleArray.append(item.name)
                self!.circleItemArray.append(item)
            }
            
            self!.selectedCircleItem = self!.circleItemArray.first!
            self!.loadBbsListByCircle(self!.selectedCircleItem,true)
            self!.segment.sectionTitles = titleArray
            self!.segment.setSelectedSegmentIndex(0, animated: false)
        }
    }
    
    
    private func loadBbsListByCircle(_ circleItem:DiscoveryCircleItem,_ isFirest:Bool) {
        if isFirest {
            circleItem.pageIndex = 0
        }
        ApiLoadingProvider.request(HTApi.getBbsListByCircle(circle: circleItem.id, pageIdex: circleItem.pageIndex), model: DiscoveryBbsList.self) { [weak self] (bbsList, error) in
            self!.tableView.htFoot.isHidden = false
            self!.tableView.htHead.endRefreshing()
            self!.tableView.htFoot.endRefreshing()
            
            if error != nil || bbsList == nil || bbsList?.data == nil {
                return
            }
            
            if bbsList!.data?.count == 0 {
                self!.tableView.htFoot.endRefreshingWithNoMoreData()
            }
            
            circleItem.pageIndex += 1
            for item in bbsList!.data! {
                let _ = item.cellHeight
                circleItem.items.append(item)
            }
            self!.tableView.reloadData()
            if isFirest {
                self!.view.layoutIfNeeded()
                self!.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            }
        }
    }

}

extension HTFCircleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedCircleItem.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HTDisBbsCell") as! HTDisBbsCell
        cell.configCell(self.selectedCircleItem.items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.selectedCircleItem.items[indexPath.row]
        return item.cellHeight
    }
}
