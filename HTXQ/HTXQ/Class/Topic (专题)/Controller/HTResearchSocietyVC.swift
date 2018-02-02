//
//  HTResearchSocietyVC.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/24.
//  Copyright © 2018年 baoqianli. All rights reserved.
//  研究社

import UIKit


class HTResearchSocietyVC: HTBaseViewController {
    
    let bannerH: CGFloat = 175.0
    var currenLoadPage = 0
    var pageSize = 0
    var dataArray = [RCPlateItem]()
    
    lazy var headView: ZCycleView = {
        let cv = ZCycleView()
        cv.timeInterval = 3
        cv.itemSize = CGSize(width: kScreenWidth-40, height: bannerH)
        cv.itemSpacing = 5
        cv.pageControlIndictirColor = UIColor.gray
        cv.pageControlCurrentIndictirColor = UIColor.white
        cv.pageControlAlignment = .right
        cv.placeholderImage = UIImage.init(named: kPlaceholder)
        return cv
    }()
    
    
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: CGRect.zero, style: .grouped)
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.delegate = self
        tb.rowHeight = 256
        tb.backgroundColor = UIColor.init(hexString: "fafafa")
        tb.register(HTRCTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(HTRCTableViewCell.self))
        tb.htHead = HTRefreshAutoHeader { [weak self] in
            self!.loadBannerData()
        }
        tb.htFoot = HTRefreshAutoFooter { [weak self] in
            self!.loadResearch(false)
        }
        tb.htFoot.isHidden = true
        return tb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBannerData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
    }
    
    private func loadBannerData() {
        ApiLoadingProvider.request(HTApi.getResearchCommunityBannerList(city: "深圳"), model: HTRCBannerModel.self) { [weak self] (dataModel, error) in
            self!.loadResearch(true)
            if dataModel == nil || error != nil {return}
            
            var imgStrs = [String]()
            for item in dataModel!.data! {
                if !item.imageUrl.isEmpty {
                    imgStrs.append(item.imageUrl)
                }
            }
            self!.headView.frame = CGRect.init(x: 0, y: 0, width: self!.view.width, height: self!.bannerH)
            self!.headView.setUrlsGroup(imgStrs)
            
        }
    }
    
    private func loadGroupResearch() {
        ApiLoadingProvider.request(HTApi.getResearchCommunityFirstPageInfo, model: RCGroupModel.self) { (dataM, error) in
            if dataM == nil || error != nil {return}
            guard dataM!.data != nil else{return}
            
        }
    }
    
    private func loadResearch(_ first: Bool) {
        if first {
            currenLoadPage = 0
            self.dataArray.removeAll()
        }
        
        ApiProvider.request(HTApi.getNewResearchCommunitys(pageIndex: currenLoadPage), model: RCPlateItemList.self) { [weak self] (dataM, error) in
            self!.tableView.htHead.endRefreshing()
            self!.tableView.htFoot.isHidden = false
            self!.tableView.htFoot.endRefreshing()
            if dataM == nil || error != nil {return}
            guard dataM?.data != nil else{return}
            if first {
                self!.tableView.tableHeaderView = self!.headView
            }
            if dataM!.data?.count == 0 {
                self?.tableView.htFoot.endRefreshingWithNoMoreData()
            }
            self!.currenLoadPage += 1
            self!.dataArray.append(contentsOf: dataM!.data!)
            self!.tableView.reloadData()
        }
    }

}

extension HTResearchSocietyVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HTRCTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(HTRCTableViewCell.self)) as! HTRCTableViewCell
        let item = self.dataArray[indexPath.row]
        cell.refreshWithData(item: item)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.dataArray.count > 0 ? 50 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lb = UILabel()
        lb.textColor = UIColor.init(hexString: "333333")
        lb.font = UIFont.boldSystemFont(ofSize: 17)
        lb.text = "   最新内容"
        return lb
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
