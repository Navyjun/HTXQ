//
//  HTInterestHeadCell.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/24.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit

class HTInterestHeadCell: HTBaseCollectionViewCell {
    public var HeadCellH: CGFloat = 268.0
    
    var dataModel: PlateViewModel?
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let fy = UICollectionViewFlowLayout()
        fy.minimumInteritemSpacing = 10.0
        fy.scrollDirection = .horizontal
        fy.itemSize = CGSize.init(width: 300.0, height: HeadCellH)
        return fy
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.white
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(HTHeadItemCell.self, forCellWithReuseIdentifier: NSStringFromClass(HTHeadItemCell.self))
        return cv
    }()
    
    
    override func setupUI() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray
        addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    class func getCellH() -> CGFloat {
        return 268.0
    }
    
    func refreshCell(_ model: PlateViewModel) {
        dataModel = model
        collectionView.reloadData()
    }
}

extension HTInterestHeadCell : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard ((dataModel?.articleForFirstPlateViews) != nil) else {
            return 0
        }
        return dataModel!.articleForFirstPlateViews!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = NSStringFromClass(HTHeadItemCell.self)
        let cell: HTHeadItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! HTHeadItemCell
        cell.refreshUI(dataModel!.articleForFirstPlateViews![indexPath.item])
        return cell
    }
    
}

class HTHeadItemCell: HTBaseCollectionViewCell {
    let imgH: CGFloat = 173.0
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var enNameL: UILabel = {
        let lb = UILabel()
        lb.text = "enNameL"
        lb.textColor = UIColor.black
        lb.font = UIFont.boldSystemFont(ofSize: 20.0)
        return lb
    }()
    
    lazy var cnNameL: UILabel = {
        let lb = UILabel()
        lb.text = "cnNameL"
        lb.textColor = UIColor.init(hexString: "333333")
        lb.font = UIFont.systemFont(ofSize: 15.0)
        return lb
    }()
    
    override func setupUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(imgH)
        }
        
        addSubview(enNameL)
        enNameL.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15.0)
            $0.top.equalTo(imageView.snp.bottom).offset(20.0)
        }
        
        addSubview(cnNameL)
        cnNameL.snp.makeConstraints {
            $0.left.equalTo(enNameL.snp.left)
            $0.top.equalTo(enNameL.snp.bottom).offset(15.0)
        }
    }
    
    func refreshUI(_ item: PlateViewsItem)  {
        imageView.setImageWith(URL(string:item.imgUrl ?? ""), options: .setImageWithFadeAnimation)
        enNameL.text = item.enName ?? ""
        cnNameL.text = item.cnName ?? ""
    }
    
}

