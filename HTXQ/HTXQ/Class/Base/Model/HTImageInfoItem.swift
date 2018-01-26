//
//  HTImageInfoItem.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/26.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit
import HandyJSON
/*
 FileSize =     {
 value = 99512;
 };
 Format =     {
 value = jpg;
 };
 ImageHeight =     {
 value = 967;
 };
 ImageWidth =     {
 value = 690;
 };
 */

struct HTImageInfoItem: HandyJSON {
    var FileSize :Info?
    var Format :Info?
    var ImageHeight :Info?
    var ImageWidth :Info?
}

struct Info: HandyJSON {
    var value :String?
}


