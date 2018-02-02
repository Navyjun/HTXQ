//
//  HTFRecommendViewController.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/30.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit

class HTFRecommendViewController: HTBaseViewController {
   
    let sectionInsetLR: CGFloat = 10.0
    let lineSpacing : CGFloat = 4.0
    var itemWH: CGFloat = 0.0
    
    
    var groupDaraArray = [DiscoveryGroupItem]()
    var recommendGroupItem = DiscoveryGroupItem()
    
    var currenLoadPage = 0
    
    lazy var flowLayout: HJCollectionViewWaterfallLayout = {
        let fy = HJCollectionViewWaterfallLayout()
        fy.delegate = self
        return fy
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = UIColor.init(hexString: "fafafa")
        cv.delegate = self
        cv.dataSource = self
        cv.register(HTDisRecommenCell.self, forCellWithReuseIdentifier: NSStringFromClass(HTDisRecommenCell.self))
        cv.register(HTDisBannerCell.self, forCellWithReuseIdentifier: NSStringFromClass(HTDisBannerCell.self))
        cv.register(HTInterestReusableView.self, forSupplementaryViewOfKind: HJElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(HTInterestReusableView.self))
        cv.htHead = HTRefreshAutoHeader{ [weak self] in
            self!.loadBannerData()
        }
        cv.htFoot = HTRefreshAutoFooter { [weak self] in
            self!.loadItemList(false)
        }
        cv.htFoot.isHidden = true
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBannerData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
    }
    
    private func loadBannerData() {
        ApiLoadingProvider.request(HTApi.getDiscoveryHomePageBannerList(city: "深圳"), model: HTDiscoveryModel.self) { [weak self] (bannerM, error) in
            self!.groupDaraArray.removeAll()
            self?.loadItemList(true)
            if error != nil || bannerM == nil || bannerM?.data == nil{
                self!.groupDaraArray.append(self!.recommendGroupItem)
                return
            }
            let disGroup = DiscoveryGroupItem()
            disGroup.itemCount = 1
            disGroup.identifier = NSStringFromClass(HTDisBannerCell.self)
            disGroup.itemSize = CGSize.init(width: kScreenWidth, height: HTDisBannerCell.getCellHeight())
            disGroup.items.append(contentsOf: bannerM!.data!)
            self!.groupDaraArray.append(disGroup)
            self!.groupDaraArray.append(self!.recommendGroupItem)
        }
    }
    
    private func loadItemList(_ isFirst: Bool) {
        
        if isFirst {
            currenLoadPage = 0
        }
        ApiLoadingProvider.request(HTApi.getDiscoveryRecommendBbs(pageIndex: currenLoadPage), model: HTDiscoveryModel.self) { [weak self] (model, error) in
            self!.collectionView.htHead.endRefreshing()
            self!.collectionView.htFoot.endRefreshing()
            self!.collectionView.htFoot.isHidden = false
            
            if error != nil || model == nil || model?.data == nil{
                self!.collectionView.reloadData()
                return
            }
            
            self!.currenLoadPage += 1
            
            if model!.data?.count == 0 {
                self?.collectionView.htFoot.endRefreshingWithNoMoreData()
            }
            
            let disGroup = self!.recommendGroupItem
            disGroup.identifier = NSStringFromClass(HTDisRecommenCell.self)
            disGroup.columCountAtSection = 2
            disGroup.minimumLineSpacing = self!.lineSpacing
            disGroup.minimumInteritemSpacing = self!.lineSpacing
            disGroup.sectionHeadTitle = "今日精选内容"
            disGroup.senctionHeadH = 55
            disGroup.sectionInset = UIEdgeInsets.init(top: 0, left: self!.sectionInsetLR, bottom: 0, right: self!.sectionInsetLR)
            if self!.itemWH == 0 {
                self!.itemWH = (kScreenWidth - 2*self!.sectionInsetLR - self!.lineSpacing)/CGFloat(disGroup.columCountAtSection)
            }
            disGroup.itemSize = CGSize.init(width: self!.itemWH, height: self!.itemWH)
            disGroup.items.append(contentsOf: model!.data!)
            disGroup.itemCount = disGroup.items.count
            self!.collectionView.reloadData()
        }
    }
    
}

extension HTFRecommendViewController: UICollectionViewDataSource, HJCollectionViewWaterfallLayoutDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return groupDaraArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model = groupDaraArray[section]
        return model.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = groupDaraArray[indexPath.section]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.identifier, for: indexPath)
        if cell.isKind(of: HTDisBannerCell.self) {
            let bannerCell = cell as! HTDisBannerCell
            bannerCell.refreshData(model)
        }else if cell.isKind(of: HTDisRecommenCell.self) {
            let recommendCell = cell as! HTDisRecommenCell
            recommendCell.refreshData(model.items[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let model = groupDaraArray[indexPath.section]
        var reusableView = UICollectionReusableView()
        if kind == HJElementKindSectionHeader {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: HJElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(HTInterestReusableView.self), for: indexPath)
            if reusableView.isKind(of: HTInterestReusableView.self) {
                let head = reusableView as! HTInterestReusableView
                head.titleLabel.text = model.sectionHeadTitle
            }
        }
        return reusableView
    }
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize {
        let model = groupDaraArray[indexPath.section]
        return model.itemSize
    }
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, columCountAtSection section: Int) -> Int {
        let model = groupDaraArray[section]
        return model.columCountAtSection
    }
    
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, heightForHeaderAtSection section: Int) -> CGFloat {
        let model = groupDaraArray[section]
        return model.senctionHeadH
    }
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, insetForSection section: Int) -> UIEdgeInsets {
        let model = groupDaraArray[section]
        return model.sectionInset
    }
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, minimumInteritemSpacingForSection section: Int) -> CGFloat {
        let model = groupDaraArray[section]
        return model.minimumInteritemSpacing
    }
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, minimumLineSpacingForSection section: Int) -> CGFloat {
        let model = groupDaraArray[section]
        return model.minimumLineSpacing
    }
}
