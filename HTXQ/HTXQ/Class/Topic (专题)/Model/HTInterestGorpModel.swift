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

struct GruopModel: HandyJSON {
    var communityHomePageFirstPlateView     : PlateViewModel?
    var communityHomePageSecondPlateView    : PlateViewModel?
    var communityHomePageWaterFallPlateView : PlateViewModel?
    
}

struct PlateViewModel: HandyJSON {
    var name       :String?
    var identifier :String?
    var itemCount  :Int = 0
    var columCountAtSection :Int = 1
    
    var modelStyle :PlateViewModelStyle!
    
    var articleForFirstPlateViews   :[PlateViewsItem]?
    var categoryForSecondPlateViews :[PlateViewsItem]?
    var articleWaterFallPlateViews :[PlateViewsItem] = []
    
    var headCellStyle               :InterestHeadStyle?
    
    var PlateViews :[PlateViewsItem]?{
        mutating get{
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
    
}

struct RecommendArticleItemList: HandyJSON {
    var code : String!
    var text : String!
    var data : [PlateViewsItem]?
}

struct PlateViewsItem: HandyJSON{
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
    
    var isVideo   :Bool = false
    
    
}

