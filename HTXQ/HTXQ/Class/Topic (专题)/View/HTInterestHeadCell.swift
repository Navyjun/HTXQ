//
//  HTInterestHeadCell.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/24.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit

enum InterestHeadStyle {
    case bannerStyle
    case specialStyle
}

class HTInterestHeadCell: HTBaseCollectionViewCell {
    let HeadCellH: CGFloat = 253.0
    var dataModel: PlateViewModel?
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let fy = UICollectionViewFlowLayout()
        fy.scrollDirection = .horizontal
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
        cv.register(HTSpecialCell.self, forCellWithReuseIdentifier: NSStringFromClass(HTSpecialCell.self))
        return cv
    }()
    
    
    override func setupUI() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-15.0)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray
        addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    class func getCellH(_ style: InterestHeadStyle) -> CGFloat {
        return style == .bannerStyle ? 268.0 : 105.0
    }
    
    public func refreshCell(_ model: PlateViewModel) {
        dataModel = model
        guard (dataModel != nil) else {
            return
        }
        collectionView.reloadData()
    }
}

extension HTInterestHeadCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard ((dataModel?.PlateViews) != nil) else {
            return 0
        }
        return dataModel!.PlateViews!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = dataModel?.headCellStyle == .bannerStyle ? NSStringFromClass(HTHeadItemCell.self) : NSStringFromClass(HTSpecialCell.self)
        let cell: HTBaseInterestItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! HTBaseInterestItemCell
        cell.refreshUI(dataModel!.PlateViews![indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return dataModel?.headCellStyle == .bannerStyle ? CGSize.init(width: 300.0, height: HeadCellH) : CGSize.init(width: 90.0, height: 90.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return dataModel?.headCellStyle == .bannerStyle ? 10.0 : 6.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftInset = dataModel?.headCellStyle == .bannerStyle ? 0 : 15
        return UIEdgeInsetsMake(0, CGFloat(leftInset), 0, 0)
    }
    
}

class HTBaseInterestItemCell: HTBaseCollectionViewCell {
    open func refreshUI(_ item: PlateViewsItem)  {}
}

class HTHeadItemCell: HTBaseInterestItemCell {
    let imgH: CGFloat = 173.0
    
    lazy var imageView: UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.lightGray
        iv.contentMode = .center
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var enNameL: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.font = UIFont.boldSystemFont(ofSize: 20.0)
        return lb
    }()
    
    lazy var cnNameL: UILabel = {
        let lb = UILabel()
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
    
    override func refreshUI(_ item: PlateViewsItem)  {
        imageView.contentMode = .center
        imageView.layer.setImageWith(URL(string:item.imgUrl ?? ""), placeholder: UIImage.init(named: kPlaceholderBig), options: .avoidSetImage) { [weak self] (image, url, form, stage, error) in
            if image != nil {
                self!.imageView.contentMode = .scaleAspectFill
                self!.imageView.layer.contents = image?.cgImage
            }
        }
        enNameL.text = item.enName ?? ""
        cnNameL.text = item.cnName ?? ""
    }
    
}

class HTSpecialCell: HTBaseInterestItemCell {
    
    lazy var imageView: UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .center
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var enNameL: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 14.0)
        lb.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        return lb
    }()
    
    override func setupUI() {
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        addSubview(enNameL)
        enNameL.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
    }
    
    override func refreshUI(_ item: PlateViewsItem)  {
        imageView.contentMode = .center
        imageView.layer.setImageWith(URL(string:item.img ?? ""), placeholder: UIImage.init(named: kPlaceholder), options: .avoidSetImage) { [weak self] (image, url, form, stage, error) in
            if image != nil {
                self!.imageView.contentMode = .scaleAspectFill
                self!.imageView.layer.contents = image?.cgImage
            }
        }
        enNameL.text = item.name ?? ""
    }
}

