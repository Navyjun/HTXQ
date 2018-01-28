//
//  HTInterestGroupVC.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/23.
//  Copyright © 2018年 baoqianli. All rights reserved.
//  兴趣组

import UIKit
import HandyJSON
import Alamofire
import MJRefresh
import MBProgressHUD
import YYKit

class HTInterestGroupVC: HTBaseCollectionViewController {
    
    let waterfallColumCount = 2
    let lineInteritemSpacing:CGFloat = 6
    let waterfallLREdgeInset:CGFloat = 10
    let waterfallItemW = (kScreenWidth - 20 - 6)*0.5
   
    var groupDataArray = [PlateViewModel]()
    var waterFallM : PlateViewModel?
    var currentPageNo  = 0
    
    
    lazy var flowLayout: HJCollectionViewWaterfallLayout = {
        let fy = HJCollectionViewWaterfallLayout() //UICollectionViewFlowLayout()
        fy.minimumInteritemSpacing = 0.0
        fy.delegate = self
        return fy
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = UIColor.init(hexString: "f0f0f0")
        cv.delegate = self
        cv.dataSource = self
        cv.register(HTInterestHeadCell.self, forCellWithReuseIdentifier: NSStringFromClass(HTInterestHeadCell.self))
        cv.register(HTITWaterfallCell.self, forCellWithReuseIdentifier: NSStringFromClass(HTITWaterfallCell.self))
        cv.register(HTInterestReusableView.self, forSupplementaryViewOfKind: HJElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(HTInterestReusableView.self))
        cv.htHead = HTRefreshAutoHeader{ [weak self] in
            self!.loadHeadData()
        }
        cv.htFoot = HTRefreshAutoFooter { [weak self] in
            self!.loadRecommendArticleData(false)
        }
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadHeadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(kNavBarH)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    private func loadHeadData()  {
        self.groupDataArray.removeAll()
        ApiLoadingProvider.request(HTApi.getHomePage(city: "深圳"), model: GruopModel.self) { [weak self] (groupM, stateCode) in
            self?.collectionView.htHead.endRefreshing()
            guard stateCode == kloadSuccessCode else{ return }

            guard (groupM != nil) else{ return }
            
            let firstM = groupM!.communityHomePageFirstPlateView
            if firstM != nil {
                firstM!.itemCount = 1
                firstM!.columCountAtSection = 1
                firstM!.modelStyle = .modelForBanner
                firstM!.headCellStyle = .bannerStyle
                firstM!.identifier = NSStringFromClass(HTInterestHeadCell.self)
                self!.groupDataArray.append(firstM!)
            }
        
            let secondM = groupM!.communityHomePageSecondPlateView
            if secondM != nil {
                secondM!.itemCount = 1
                secondM!.columCountAtSection = 1
                secondM!.modelStyle = .modelForSpecial
                secondM!.headCellStyle = .specialStyle
                secondM!.identifier = NSStringFromClass(HTInterestHeadCell.self)
                self!.groupDataArray.append(secondM!)
            }
            
            let waterFallM = groupM!.communityHomePageWaterFallPlateView
            if waterFallM != nil {
                waterFallM!.itemCount = 0
                waterFallM!.columCountAtSection = self!.waterfallColumCount
                waterFallM!.modelStyle = .modelForRecommends
                waterFallM!.identifier = NSStringFromClass(HTITWaterfallCell.self)
                self!.waterFallM = waterFallM
                self!.groupDataArray.append(self!.waterFallM!)
                self!.loadRecommendArticleData(true)
            }
            self!.collectionView.reloadData()
        }
    }
    
    func loadRecommendArticleData(_ first: Bool) {
        if first {
            currentPageNo = 8
        }
    
        ApiLoadingProvider.request(HTApi.getRecommendArticleList(pageIndex: currentPageNo)) { [weak self] (result) in
            HTLog("++++foot refresh++++++\(String(describing: self?.currentPageNo))")
            
            if result.error != nil {
                self?.collectionView.htFoot.endRefreshing()
                return
            }
            
            let jsonString = String(data: (result.value?.data)!, encoding: .utf8)
            guard let model = JSONDeserializer<RecommendArticleItemList>.deserializeFrom(json: jsonString) else{
                self?.collectionView.htFoot.endRefreshing()
                return
            }
            
            guard model.data != nil && self!.waterFallM != nil else{
                self?.collectionView.htFoot.endRefreshing()
                return
            }
            
            if model.data?.count == 0 {
                self?.collectionView.htFoot.endRefreshing()
                return
            }
        
            var array = [PlateViewsItem]()
            MBProgressHUD.showAdded(to: self!.view, animated: false)
            for item in model.data! {
                item.ImageWidth = self!.waterfallItemW
                
                getImageInfo(item: item, completion: { (newItem) in
                   array.append(item)
                    
                   if array.count == model.data!.count {
                    self!.currentPageNo += 1
                    self!.waterFallM!.articleWaterFallPlateViews.append(contentsOf: array)
                    self!.waterFallM!.itemCount = self!.waterFallM!.articleWaterFallPlateViews.count
                    self!.collectionView.reloadData()
                    MBProgressHUD.hide(for: self!.view, animated: false)
                    
                    if !first {
                        self?.collectionView.htFoot.endRefreshing()
                     }
                    
                   }
                })
            }
            

        }
    }
    
}

extension HTInterestGroupVC : UICollectionViewDataSource, HJCollectionViewWaterfallLayoutDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return groupDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model: PlateViewModel = groupDataArray[section]
        return model.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model: PlateViewModel = groupDataArray[indexPath.section]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.identifier!, for: indexPath)
        if model.modelStyle == .modelForSpecial || model.modelStyle == .modelForBanner {
            let headCell = cell as! HTInterestHeadCell
            headCell.refreshCell(model)
            return headCell
        }else if model.modelStyle == .modelForRecommends {
            let waterfallCell = cell as! HTITWaterfallCell
            waterfallCell.refreshData(item: model.PlateViews![indexPath.item])
            return waterfallCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let model: PlateViewModel = groupDataArray[indexPath.section]
        var reusableView = UICollectionReusableView()
        
        if kind == HJElementKindSectionHeader && (model.modelStyle == .modelForSpecial || model.modelStyle == .modelForRecommends) {
            let model: PlateViewModel = groupDataArray[indexPath.section]
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: HJElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(HTInterestReusableView.self), for: indexPath)
            if reusableView.isKind(of: HTInterestReusableView.self) {
                let head = reusableView as! HTInterestReusableView
                head.backgroundColor = model.modelStyle == .modelForSpecial ? UIColor.white : UIColor.clear
                head.titleLabel.text = model.name
            }
        }
        
        return reusableView
    }
    
   
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, columCountAtSection section: Int) -> Int {
        let model: PlateViewModel = groupDataArray[section]
        return model.columCountAtSection
    }
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize {
        let model: PlateViewModel = groupDataArray[indexPath.section]
        let ms = model.modelStyle
        if ms == .modelForBanner || ms == .modelForSpecial {
            return CGSize.init(width: kScreenWidth, height: HTInterestHeadCell.getCellH(model.headCellStyle!))
        }else if ms == .modelForRecommends{
            let item = model.PlateViews![indexPath.item]
            return CGSize.init(width: item.ImageWidth, height: item.ImageHeight+item.bottomH)
        }else{
            return CGSize.zero
        }
    }
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, heightForHeaderAtSection section: Int) -> CGFloat {
        let model: PlateViewModel = groupDataArray[section]
        if model.modelStyle == .modelForSpecial || model.modelStyle == .modelForRecommends {
            return 55
        }
        return 0
    }
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, insetForSection section: Int) -> UIEdgeInsets {
        let model: PlateViewModel = groupDataArray[section]
        if model.modelStyle == PlateViewModelStyle.modelForRecommends {
            return UIEdgeInsetsMake(0, waterfallLREdgeInset, 0, waterfallLREdgeInset)
        }
        return UIEdgeInsets.zero
    }
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, minimumInteritemSpacingForSection section: Int) -> CGFloat {
        let model: PlateViewModel = groupDataArray[section]
        if model.modelStyle == PlateViewModelStyle.modelForRecommends {
            return lineInteritemSpacing
        }
        return 0
    }
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, minimumLineSpacingForSection section: Int) -> CGFloat {
        let model: PlateViewModel = groupDataArray[section]
        if model.modelStyle == PlateViewModelStyle.modelForRecommends {
            return lineInteritemSpacing
        }
        return 0
    }
}

