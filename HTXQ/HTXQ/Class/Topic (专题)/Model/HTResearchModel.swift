//
//  HTResearchModel.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/29.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit
import HandyJSON

class HTRCBannerModel: HandyJSON {
    var code : String!
    var text : String!
    var data : [RCBannerItem]?
    
    required init() {}
}

class RCBannerItem: HandyJSON {
    var title = ""
    var imageUrl = ""
    var type = ""
    var jumpId = ""
    var detailUrl = ""
    
    required init() {}
}

class RCGroupModel: HandyJSON {
    var code : String!
    var text : String!
    var data : RCGroupItem?
    
    required init() {}
}

class RCGroupItem: HandyJSON {
    var firstPlateTitle = ""
    var secondPlateTitle = ""
    var someTimesFreeSubjects: [RCPlateItem]?
    
    var title = ""
    var items = [RCPlateItem]()
    
    required init() {}
}

class RCPlateItemList: HandyJSON {
    var code : String!
    var text : String!
    var data : [RCPlateItem]?
    
    required init() {}
}

class RCPlateItem: HandyJSON {
    var id = 0
    var price = 0.00
    var readCount = 0
    var imgUrl = ""
    var title = ""
    var content = ""
    var typeName = ""
    
    required init() {}
}
