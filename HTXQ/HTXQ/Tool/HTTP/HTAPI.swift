//
//  HTAPI.swift
//  HTXQ
//
//  Created by 张海军 on 2018/1/23.
//  Copyright © 2018年 baoqianli. All rights reserved.
//

import UIKit
import Moya
import HandyJSON
import MBProgressHUD

let LoadingPlugin = NetworkActivityPlugin { (type, target) in
    guard let vc = getTopVC() else { return }
    switch type {
    case .began:
        MBProgressHUD.hide(for: vc.view, animated: false)
        MBProgressHUD.showAdded(to: vc.view, animated: true)
    case .ended:
        MBProgressHUD.hide(for: vc.view, animated: true)
    }
}

let timeoutClosure = {(endpoint: Endpoint<HTApi>, closure: MoyaProvider<HTApi>.RequestResultClosure) -> Void in
    
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}


let ApiProvider = MoyaProvider<HTApi>()
let ApiLoadingProvider = MoyaProvider<HTApi>(requestClosure: timeoutClosure, plugins: [LoadingPlugin])


enum HTApi {
    case getHomePage(city:String)
    case getRecommendArticleList(pageIndex:Int)
}

extension HTApi: TargetType{
    
    var baseURL: URL {
        return URL.init(string: "http://api.htxq.net/cactus/")!
    }
    
    var path: String {
        switch self {
        case .getHomePage: return "communityHomePage/getHomePageForNewVersion"
        case .getRecommendArticleList: return "sysArticle/getRecommendArticleListV2"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var parmeters = [String:Any]()
        switch self {
        case .getHomePage(let city):
            parmeters["city"] = city
            
        case .getRecommendArticleList(let pageIndex):
            parmeters["pageIndex"]  = pageIndex
            parmeters["customerId"] = "e124f7e6-6fb5-4016-bfca-193007619002"
            parmeters["token"]      = "235C15369ADE6F17B649C4E06A68FDB2"
        }
        
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
   
    var headers: [String : String]? {
        let headDic = ["client-version":"6.0.0",
                       "client-channel":"AppStore",
                       "client-terminal":UIDevice.current.machineModelName,
                       "client-platform":"iOS"+UIDevice.current.systemVersion,
                       "cclient-unique":UIDevice.current.identifierForVendor?.uuidString]
        return headDic as? [String : String]
    }
    
}

extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        let jsonString = String(data: data, encoding: .utf8)
        
//        let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//        HTLog("dict = \(String(describing: dict))")
        
        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            throw MoyaError.jsonMapping(self)
        }
        return model
    }
}


extension MoyaProvider {
    @discardableResult
    open func request<T: HandyJSON>(_ target: Target,
                                    model: T.Type,
                                    completion: ((_ returnData: T?, _ code: String) -> Void)?) -> Cancellable? {
        
        return request(target, completion: { (result) in
            guard let completion = completion else { return }
            guard let returnData = try? result.value?.mapModel(ResponseData<T>.self) else {
                completion(nil,"解析出错")
                return
            }
            completion(returnData!.data,returnData!.code)
        })
    }
}

/*
 "code": "000000",
 "text": "成功",
 "data":
 */
struct ResponseData<T: HandyJSON>: HandyJSON {
    var code : String!
    var text : String!
    var data : T?
}
