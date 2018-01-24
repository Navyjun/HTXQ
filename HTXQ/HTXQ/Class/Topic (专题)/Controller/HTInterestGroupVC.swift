//
//  HTInterestGroupVC.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/23.
//  Copyright © 2018年 baoqianli. All rights reserved.
//  兴趣组

import UIKit
import HandyJSON


class HTInterestGroupVC: HTBaseCollectionViewController {
    
    var groupDataArray = [PlateViewModel]()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let fy = UICollectionViewFlowLayout()
        fy.minimumInteritemSpacing = 0.0
        fy.scrollDirection = .vertical
        return fy
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = UIColor.clear
        cv.delegate = self
        cv.dataSource = self
        
        cv.register(HTInterestHeadCell.self, forCellWithReuseIdentifier: NSStringFromClass(HTInterestHeadCell.self))
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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

    private func loadData()  {
        ApiLoadingProvider.request(HTApi.getHomePage(city: "深圳"),
                                   model: GruopModel.self) { (groupM, stateCode) in
                                    HTLog(stateCode)
                                    HTLog(groupM?.communityHomePageFirstPlateView?.name)
                                    
                                    if groupM?.communityHomePageFirstPlateView != nil {
                                        var plateViewM = groupM!.communityHomePageFirstPlateView!
                                        plateViewM.identifier = NSStringFromClass(HTInterestHeadCell.self)
                                        self.groupDataArray.append(plateViewM)
                                        self.collectionView.reloadData()
                                    }
                                        
                                    
        }
    }

}

extension HTInterestGroupVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return groupDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model: PlateViewModel = groupDataArray[indexPath.section]
        let cell: HTInterestHeadCell = collectionView.dequeueReusableCell(withReuseIdentifier: model.identifier!, for: indexPath) as! HTInterestHeadCell
        cell.refreshCell(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize.init(width: kScreenWidth, height: HTInterestHeadCell.getCellH())
        }
        return CGSize.zero
    }
    
}


