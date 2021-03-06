//
//  HTGlobal.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/22.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import HandyJSON

public let kScreenWidth = UIScreen.main.bounds.width
public let kScreenHeight = UIScreen.main.bounds.height
public let kNavBarH = 64.0

public let kUserHeadPlaceholder = "ic_account"
public let kPlaceholder = "placehodlerX"
public let kPlaceholderBig = "LOGO_85x85_"

public let kloadSuccessCode = "000000"

/// 随机色
///
/// - Returns: 随机色
public func randColor() -> UIColor {
    return UIColor.init(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1)
}


/// rgb
///
/// - Parameters:
///   - r: 红色
///   - g: 绿色
///   - b: 蓝色
///   - alpha: 透明度
/// - Returns: uicolor
public func HTColor(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ alpha:CGFloat) -> UIColor {
    return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
}

/// 获取当前顶层控制器
///
/// - Returns: 顶层控制器
public func getTopVC() -> UIViewController? {
    var resultVC: UIViewController?
    resultVC = _topVC(UIApplication.shared.keyWindow?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)
    }
    return resultVC
}

private  func _topVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        return _topVC((vc as? UINavigationController)?.topViewController)
    } else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)
    } else {
        return vc
    }
}


/// 打印
func HTLog<T>(_ message: T, file: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):funciton:\(function):line:\(lineNumber)]- \(message)")
    #endif
}

//MARK: SnapKit
extension ConstraintView {
    
    var ksnp: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        } else {
            return self.snp
        }
    }
}


/// 通过URL地址获取图片信息
///
/// - Parameter urlStr: 图片URL地址
/// - Returns: 图片信息模型
func getImageInfo(item:PlateViewsItem, completion:((_ item:PlateViewsItem?, _ error:Error?)->())?) {
    let url = URL.init(string: item.coverImg!)!
    request(url,
            method: .get,
            parameters: ["x-oss-process":"image/info"],
            encoding: URLEncoding.default,
            headers: nil).response { (result) in
                guard completion != nil else{ return }
                if result.error != nil {
                    completion!(nil,result.error)
                    return
                }
                let jsonString = String(data: (result.data)!, encoding: .utf8)
                guard let model = JSONDeserializer<HTImageInfoItem>.deserializeFrom(json: jsonString) else{
                    return
                }
                
                let ow:NSString = ((model.ImageWidth?.value == nil) ? "0" : model.ImageWidth?.value)! as NSString
                let oh:NSString = ((model.ImageHeight?.value == nil) ? "0" : model.ImageHeight?.value)! as NSString
                let fz:NSString = ((model.FileSize?.value == nil) ? "0" : model.FileSize?.value)! as NSString
                item.ImageHeight = item.ImageWidth * CGFloat(oh.floatValue) / CGFloat(ow.floatValue)
                item.FileSize = fz.integerValue
                completion!(item,nil)
                
    }
}
