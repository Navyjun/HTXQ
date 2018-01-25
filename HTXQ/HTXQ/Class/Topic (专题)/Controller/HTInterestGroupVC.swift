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

class HTInterestGroupVC: HTBaseCollectionViewController {
    
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
        cv.backgroundColor = UIColor.clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(HTInterestHeadCell.self, forCellWithReuseIdentifier: NSStringFromClass(HTInterestHeadCell.self))
        
        cv.register(HTInterestReusableView.self, forSupplementaryViewOfKind: HJElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(HTInterestReusableView.self))
        
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
        ApiLoadingProvider.request(HTApi.getHomePage(city: "深圳"),
                                   model: GruopModel.self) { (groupM, stateCode) in
                                
                                    guard stateCode == kloadSuccessCode else{ return }

                                    guard (groupM != nil) else{ return }
                                    
                                    self.loadRecommendArticleData(true)
                                    
                                    var firstM = groupM!.communityHomePageFirstPlateView
                                    if firstM != nil {
                                        firstM!.itemCount = 1
                                        firstM!.columCountAtSection = 1
                                        firstM!.modelStyle = .modelForBanner
                                        firstM!.headCellStyle = .bannerStyle
                                        firstM!.identifier = NSStringFromClass(HTInterestHeadCell.self)
                                        self.groupDataArray.append(firstM!)
                                    }
                                
                                    var secondM = groupM!.communityHomePageSecondPlateView
                                    if secondM != nil {
                                        secondM!.itemCount = 1
                                        secondM!.columCountAtSection = 1
                                        secondM!.modelStyle = .modelForSpecial
                                        secondM!.headCellStyle = .specialStyle
                                        secondM!.identifier = NSStringFromClass(HTInterestHeadCell.self)
                                        self.groupDataArray.append(secondM!)
                                    }
                                    
                                    self.waterFallM = groupM!.communityHomePageWaterFallPlateView
                                    
                                    self.collectionView.reloadData()
                                    
                                    
        }
    }
    
    func loadRecommendArticleData(_ first: Bool) {
        if first {
            currentPageNo = 0
        }
    
        ApiLoadingProvider.request(HTApi.getRecommendArticleList(pageIndex: currentPageNo)) { (result) in
            
            if result.error != nil {
                return
            }
            
            let jsonString = String(data: (result.value?.data)!, encoding: .utf8)
            guard let model = JSONDeserializer<RecommendArticleItemList>.deserializeFrom(json: jsonString) else{
                return
            }
            
            guard model.data != nil && self.waterFallM != nil else{
                return
            }
    
            for item in model.data! {
                self.waterFallM?.articleWaterFallPlateViews.append(item)
            }
            
            self.groupDataArray.insert(self.waterFallM!, at: 2)
            
            HTLog(self.waterFallM?.articleWaterFallPlateViews.count)
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
        let cell: HTInterestHeadCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.identifier!, for: indexPath) as! HTInterestHeadCell
        cell.refreshCell(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        var reusableView = UICollectionReusableView()
        
        if kind == HJElementKindSectionHeader && indexPath.section > 0 {
            let model: PlateViewModel = groupDataArray[indexPath.section]
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: HJElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(HTInterestReusableView.self), for: indexPath)
            if reusableView.isKind(of: HTInterestReusableView.self) {
                let head = reusableView as! HTInterestReusableView
                head.titleLabel.text = model.name
            }
        }
        
        return reusableView
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model: PlateViewModel = groupDataArray[indexPath.section]
        let ms = model.modelStyle
        if ms == .modelForBanner || ms == .modelForSpecial {
            return CGSize.init(width: kScreenWidth, height: HTInterestHeadCell.getCellH(model.headCellStyle!))
        }else{
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section > 0 {
            return CGSize.init(width: kScreenWidth, height: 55)
        }
        return CGSize.zero
    }
    */
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, columCountAtSection section: Int) -> Int {
        let model: PlateViewModel = groupDataArray[section]
        return model.columCountAtSection
    }
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize {
        let model: PlateViewModel = groupDataArray[indexPath.section]
        let ms = model.modelStyle
        if ms == .modelForBanner || ms == .modelForSpecial {
            return CGSize.init(width: kScreenWidth, height: HTInterestHeadCell.getCellH(model.headCellStyle!))
        }else{
            return CGSize.zero
        }
    }
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, heightForHeaderAtSection section: Int) -> CGFloat {
        if section > 0 {
            return 55
        }
        return 0
    }
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, insetForSection section: Int) -> UIEdgeInsets {
        let model: PlateViewModel = groupDataArray[section]
        if model.modelStyle == PlateViewModelStyle.modelForRecommends {
            return UIEdgeInsetsMake(0, 15, 0, -15)
        }
        return UIEdgeInsets.zero
    }
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, minimumInteritemSpacingForSection section: Int) -> CGFloat {
        let model: PlateViewModel = groupDataArray[section]
        if model.modelStyle == PlateViewModelStyle.modelForRecommends {
            return 8
        }
        return 0
    }
    
    func hj_collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, minimumLineSpacingForSection section: Int) -> CGFloat {
        let model: PlateViewModel = groupDataArray[section]
        if model.modelStyle == PlateViewModelStyle.modelForRecommends {
            return 8
        }
        return 0
    }
}


