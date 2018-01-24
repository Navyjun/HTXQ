//
//  HTInterestGorpModel.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/24.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit
import HandyJSON

struct GruopModel: HandyJSON {
    var communityHomePageFirstPlateView  : PlateViewModel?
    var communityHomePageSecondPlateView : PlateViewModel?
}

struct PlateViewModel: HandyJSON {
    var name       :String?
    var identifier :String?
    var articleForFirstPlateViews : [PlateViewsItem]?
    
}

struct PlateViewsItem: HandyJSON{
    var articleId :String?
    var cnName    :String?
    var detailUrl :String?
    var enName    :String?
    var imgUrl    :String?
    var img       :String?
    var name      :String?
    var id        :Int = 0
    var type      :Int = 0
}

