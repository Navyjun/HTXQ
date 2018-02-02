//
//  HTInterestGorpModel.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/24.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit
import HandyJSON

enum PlateViewModelStyle {
    case modelForBanner
    case modelForSpecial
    case modelForRecommends
}

class GroupModelList: HandyJSON {
    var code : String!
    var text : String!
    var data : GruopModel?
    
    required init() {}
}

class GruopModel: HandyJSON {
    var communityHomePageFirstPlateView     : PlateViewModel?
    var communityHomePageSecondPlateView    : PlateViewModel?
    var communityHomePageWaterFallPlateView : PlateViewModel?
    
    required init() { }
}

class PlateViewModel: HandyJSON {
    var name       :String?
    var identifier :String?
    var itemCount  = 0
    var columCountAtSection :Int = 1
    
    var modelStyle :PlateViewModelStyle!
    
    var articleForFirstPlateViews   :[PlateViewsItem]?
    var categoryForSecondPlateViews :[PlateViewsItem]?
    var articleWaterFallPlateViews  = [PlateViewsItem]()
    
    var headCellStyle               :InterestHeadStyle?
    
    var PlateViews :[PlateViewsItem]?{
        get{
            if modelStyle == .modelForBanner {
                return articleForFirstPlateViews
            }else if modelStyle == .modelForSpecial {
                return categoryForSecondPlateViews
            }else if modelStyle == .modelForRecommends{
                return articleWaterFallPlateViews
            }else{
                return nil
            }
        }
    }
    
    required init() { }
}

class RecommendArticleItemList: HandyJSON {
    var code : String!
    var text : String!
    var data : [PlateViewsItem]?
    
    required init() { }
}

class PlateViewsItem: HandyJSON{
    var articleId :String?
    var cnName    :String?
    var detailUrl :String?
    var enName    :String?
    var imgUrl    :String?
    var img       :String?
    var name      :String?
    var coverImg  :String?
    var cateName  :String?
    
    
    var id        :Int = 0
    var type      :Int = 0
    var readCount :Int = 0
    
    var isVideo        = false
    var isFirstLoadImg = true
    
    
    var FileSize    :Int = 0
    var ImageHeight :CGFloat = 0
    var ImageWidth  :CGFloat = 0 //3522827
    let bottomH:CGFloat = 60
    
    required init() { }
}

