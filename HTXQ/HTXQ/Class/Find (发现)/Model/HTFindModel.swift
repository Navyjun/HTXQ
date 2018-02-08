//
//  HTFindModel.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/30.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit
import HandyJSON


// mark - 发现 -> 推荐
class HTDiscoveryModel: HandyJSON {
    var code : String!
    var text : String!
    var data : [DiscoveryItem]?
    required init() {}
}

class DiscoveryGroupItem: NSObject {
    var identifier = ""
    var sectionHeadTitle = ""
    var items = [DiscoveryItem]()
    
    var itemCount = 0
    var columCountAtSection = 1
    var itemSize = CGSize.zero
    var sectionInset = UIEdgeInsets.zero
    var minimumInteritemSpacing: CGFloat = 0.0
    var minimumLineSpacing: CGFloat = 0.0
    var senctionHeadH: CGFloat = 0.0
    
}

class DiscoveryItem: HandyJSON {
    var title = ""
    var imageUrl = ""
    var imgUrl = ""
    var type = ""
    var jumpId = ""
    var detailUrl = ""
    required init() {}
}

// http://api.htxq.net/cactus/bbs/getBbsCircleList?type=1

class DiscoveryCircleList: HandyJSON {
    var code : String!
    var text : String!
    var data : [DiscoveryCircleItem]?
    required init() {}
}

class DiscoveryCircleItem: HandyJSON {
    var id = ""
    var name = ""
    var pageIndex = 0
    var scrollY:CGFloat = 0.0
    var offsetY:CGFloat = 0.0
    
    var items = [DiscoveryBbsItem]()
    required init() {}
}

class DiscoveryBbsList: HandyJSON {
    var code : String!
    var text : String!
    var data : [DiscoveryBbsItem]?
    required init() {}
}

class DiscoveryBbsItem: HandyJSON {
    public let headViewH:CGFloat = 76.0
    public let opationHandleVH:CGFloat = 44.0
    public let commMargin:CGFloat = 15.0
    public let titleSize:CGFloat = 14.0
    public let contentTitleSize:CGFloat = 12.0
    
    var title         = ""
    var createDate    = ""
    var hotTalk       = ""
    var type          = 0
    var collectCount  = 0
    var appointCount  = 0
    var commentCount  = 0
    var recommend     = false
    var bigImgList    = [String]()
    var bbsAuthor     = AuthorItem()
    
    var picsViewH     : CGFloat = 0.0
    var titleH        : CGFloat = 0.0
    var contentH      : CGFloat = 0.0
    
    var content       = ""
    var imgList       = [String]()
    
    var imgItemsArray = [ImageItem]()
    
    private var _cellHeight   : CGFloat = 0.0
    var cellHeight    : CGFloat{
         get{
            
            if _cellHeight == 0{
                //titleH = contentHWithStr(title, titleSize)
                contentH = contentHWithStr(content, contentTitleSize)
                picsViewH = picsViewHWithArray(imgList)
                self._cellHeight = headViewH + titleH + contentH + picsViewH + opationHandleVH;
            }
            return _cellHeight
        }
    }
    
    
    private  func picsViewHWithArray(_ array: [String]) -> CGFloat {
        let count = array.count
        
        if count <= 0 {
            return 0.0
        }
        
        let itemMargin:CGFloat = 4.0
        let columCount = count >= 3 ? 3 : (count % 3)
        let totalW = UIScreen.main.bounds.size.width - 2 * commMargin - CGFloat(columCount - 1) * itemMargin
        let imgWH = totalW / CGFloat(columCount)
        let rowCount = (count - 1) / columCount + 1
        
        var rowN:Int = 0
        var lineN:Int = 0
        for i in 0..<count{
            let item = ImageItem()
            item.imgURL = array[i]
            rowN = i / columCount
            lineN = i % columCount
            item.imgFrame = CGRect.init(x: (imgWH + itemMargin) * CGFloat(lineN),
                                        y: (imgWH + itemMargin) * CGFloat(rowN) + 10,
                                        width: imgWH, height: imgWH)
            imgItemsArray.append(item)
        }
        
        return imgWH * CGFloat(rowCount) + CGFloat(rowCount - 1) * itemMargin + 20;
    }
    
    
    private func contentHWithStr(_ content:String,_ fontSize:CGFloat) -> CGFloat {
        let contentStr:NSString = content as NSString
        if contentStr.length <= 0 {
            return 0.0
        }
        
        let width = UIScreen.main.bounds.size.width - 2 * commMargin
        let originSize = CGSize.init(width: width, height: CGFloat(MAXFLOAT))
        
        let H = contentStr.boundingRect(with: originSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: fontSize)], context: nil).size.height
        
        return H
    }
    
    required init() {}
}

class AuthorItem: HandyJSON {
    var customerId  = ""
    var userName    = ""
    var headImg     = ""
    var auth        = ""
    var signature   = "这个家伙很懒,什么也没留"
    
    required init() {}
}

class ImageItem: HandyJSON {
    var imgURL   = ""
    var imgFrame : CGRect = CGRect.zero
    required init() {}
}
