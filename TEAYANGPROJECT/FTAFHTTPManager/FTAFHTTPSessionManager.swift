//
//                         __   _,--="=--,_   __
//                        /  \."    .-.    "./  \
//                       /  ,/  _   : :   _  \/` \
//                       \  `| /o\  :_:  /o\ |\__/
//                        `-'| :="~` _ `~"=: |
//                           \`     (_)     `/
//                    .-"-.   \      |      /   .-"-.
//.------------------{     }--|  /,.-'-.,\  |--{     }-----------------.
// )                 (_)_)_)  \_/`~-===-~`\_/  (_(_(_)                (
//
//        File Name:       FTAFSessionManager.swift
//        Product Name:    TEAYANGPROJECT
//        Author:          xuyanzhang@上海览益信息科技有限公司
//        Swift Version:   5.0
//        Created Date:    2020/7/23 11:03 AM
//
//        Copyright © 2020 上海览益信息科技有限公司.
//        All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
        

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

typealias FTResponseSuccess = (_ response : FTResponseModel, Any) -> Void
typealias FTResponseFail = (_ error : FTErrorModel) -> Void

class FTAFHTTPSessionManager: NSObject
{
    static let shared = FTAFHTTPSessionManager()
    private var sessionManager: Session?
    
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        sessionManager = Session.init(configuration: configuration, delegate: SessionDelegate.init(), serverTrustManager: nil)
    }
    /**
     *  GET  请求
     *
     *  @param URLString  接口地址
     *  @param parameters 参数json
     *  @param success    成功
     *  @param failure    失败
     */
    func get(target: FTHTTPTarget,
             success: @escaping FTResponseSuccess,
             failure: @escaping FTResponseFail){
        requesttMethod(target: target,
                       success: success,
                       failure: failure)
    }

    /**
    *  POST  请求
    *
    *  @param URLString  接口地址
    *  @param parameters 参数json
    *  @param success    成功
    *  @param failure    失败
    */
    func post(target: FTHTTPTarget,
              success: @escaping FTResponseSuccess,
              failure: @escaping FTResponseFail){
        requesttMethod(target: target,
                       success: success,
                       failure: failure)
    }
    
    /**
    *  POST  请求  参数放body
    *
    *  @param URLString  接口地址
    *  @param parameters 参数json
    *  @param success    成功
    *  @param failure    失败
    */
    func postBody(target: FTHTTPTarget,
                  success: @escaping FTResponseSuccess,
                  failure: @escaping FTResponseFail){
        requesttMethod(target: target,
                       success: success,
                       failure: failure)
    }
    
    /**
    *  UPLOAD  请求  上传图片
    *
    *  @param URLString  接口地址
    *  @param parameters 参数json
    *  @param success    成功
    *  @param failure    失败
    */
    func uploadImage(target: FTHTTPTarget,
                  success: @escaping FTResponseSuccess,
                  failure: @escaping FTResponseFail){
        requesttMethod(target: target,
                       success: success,
                       failure: failure)
    }
    
    /**
    *  请求分发
    *
    *  @param URLString  接口地址
    *  @param parameters 参数json
    *  @param success    成功
    *  @param failure    失败
    */
    private func requesttMethod(target: FTHTTPTarget, success: @escaping FTResponseSuccess, failure: @escaping FTResponseFail) {
        switch target.method {
        case .GET:
            self.getRequest(target: target, success: success, failure: failure)
            break
        case .POST:
            self.postRequest(target: target, success: success, failure: failure)
            break
        case .POSTBODY:
            self.postBodyRequest(target: target, success: success, failure: failure)
            break
        case .UPLOAD:
            self.uploadImage(target: target, success: success, failure: failure)
            break
        default:
            break
        }
    }
}

extension FTAFHTTPSessionManager
{
    //MARK: - POST
    private func postRequest(target: FTHTTPTarget,
                    success: @escaping FTResponseSuccess,
                    failure: @escaping FTResponseFail){
        print("POST----URLString : \(target.baseUrl + target.path) \n---- headers : \(target.headers) \n---- parameters : \(String(describing: target.pararms))")
        AF.request(target.baseUrl + target.path, method: .post, parameters: target.pararms as? Parameters, encoding: URLEncoding.default, headers: target.headers).responseJSON { (response) in
            self.handleResponse(response: response, success: success, failure: failure)
        }
    }
    
    //MARK: - POST(BODY)
    private func postBodyRequest(target: FTHTTPTarget,
                             success: @escaping FTResponseSuccess,
                             failure: @escaping FTResponseFail){
        let json = JSON.init(target.pararms as Any)
        let urlReqest = URL.init(string: target.baseUrl + target.path)
        var request = URLRequest.init(url: urlReqest!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.headers = target.headers
        request.httpBody = json.description.data(using: .utf8)
        print("POST----URLString : \(target.baseUrl + target.path) \n---- headers : \(target.headers) \n---- parameters : \(String(describing: target.pararms))")
        sessionManager?.request(request).validate().responseJSON{ (response) in
            self.handleResponse(response: response, success: success, failure: failure)
        }
    }
    
    //MARK: - GET请求
    private func getRequest(target: FTHTTPTarget,
                    success: @escaping FTResponseSuccess,
                    failure: @escaping FTResponseFail){
        print("POST----URLString : \(target.baseUrl + target.path) \n---- headers : \(target.headers) \n---- parameters : \(String(describing: target.pararms))")
        AF.request(target.baseUrl + target.path, method: .get, parameters: target.pararms as? Parameters, encoding: URLEncoding.default, headers: target.headers).responseJSON{ (response) in
            self.handleResponse(response: response, success: success, failure: failure)
        }
    }
    
    //MARK: - 上传图片
    private func uploadImageRequest(target: FTHTTPTarget,
                                    success: @escaping FTResponseSuccess,
                                    failure: @escaping FTResponseFail){
        print("POST----URLString : \(target.baseUrl + target.path) \n---- headers : \(target.headers) \n---- parameters : \(String(describing: target.pararms))")
        let images = target.pararms as! Array<Any>
        self.sessionManager?.upload(multipartFormData: { (multipartFormData) in
            for data in images {
                let dataStr = DateFormatter.init()
                dataStr.dateFormat = "yyyyMMddHHmmss"
                let fileName = "\(dataStr.string(from: Date.init())).png"
                multipartFormData.append(data as! Data, withName: "file", fileName: fileName, mimeType: "image/jpg/png/jpeg")
            }
            
        }, to: target.baseUrl + target.path, headers: target.headers).responseJSON(completionHandler: { (response) in
            self.handleResponse(response: response, success: success, failure: failure)
        })
    }
}

extension FTAFHTTPSessionManager
{
    //MARK: - token替换
    private func replaceToken(response: AFDataResponse<Any>)
    {
        let headers: Dictionary = (response.request?.allHTTPHeaderFields)!
        let token: String = headers["token"] ?? ""
        let status: String = headers["token-status"] ?? ""
        if status == "new" && token.count > 0 {
            ///
        }
    }
    
    //MARK: - 响应处理
    private func handleResponse(response: AFDataResponse<Any>,
                                success: @escaping FTResponseSuccess,
                                failure: @escaping FTResponseFail)
    {
        switch response.result {
        case .success:
            replaceToken(response: response)
            let json = String(data: response.data!, encoding: String.Encoding.utf8)
            print("json :  \(String(describing: json))")
            let dict =  json?.stringValueDictionary(json!)
            let responseModel = Mapper<FTResponseModel>().map(JSON: dict!)
            if responseModel?.code == 401 {
                print("手机号登录失效")
            }
            if responseModel?.code == 403 {
                print("资金账号登录失效")
            }
            success(responseModel!, dict!)
        case .failure:
            let statusCode = response.response?.statusCode
            var message : String = ""
            if (statusCode == -1009 ) {
                message = "无网络连接";
            }else if (statusCode == -1001 ){
                message = "请求超时";
            }else if (statusCode == -1005 ){
                message = "网络连接丢失(服务器忙)";
            }else if (statusCode == -1004 ){
                message = "服务器没有启动";
            }
            failure(FTErrorModel(code: statusCode!, errorMsg: message))
        }
    }
}
