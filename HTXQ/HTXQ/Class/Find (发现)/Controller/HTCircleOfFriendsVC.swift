//
//  HTCircleOfFriendsVC.swift
//  HTXQ
//
//  Created by 张海军 on 2018/2/5.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit

class HTCircleOfFriendsVC: UITableViewController {
    
    var circleItemArray = [DiscoveryCircleItem]()
    var selectedCircleItem = DiscoveryCircleItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "HTDisBbsCell", bundle: Bundle.main), forCellReuseIdentifier: "HTDisBbsCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            self!.loadBbsListByCircle(self!.selectedCircleItem,false)
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
            circleItem.pageIndex += 1
            for item in bbsList!.data! {
                let _ = item.cellHeight
                circleItem.items.append(item)
            }
            //circleItem.items.append(contentsOf: bbsList!.data!)
            self!.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedCircleItem.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HTDisBbsCell") as! HTDisBbsCell
        cell.configCell(self.selectedCircleItem.items[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.selectedCircleItem.items[indexPath.row]
        return item.cellHeight
    }

}
