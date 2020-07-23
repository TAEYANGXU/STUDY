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

enum HTTPType {
    case GET
    case POST
    case POSTBODY
    case UPLOAD
}

let infoDictionary = Bundle.main.infoDictionary
let majorVersion :String = infoDictionary!["CFBundleShortVersionString"] as! String//应用版本号
let iOSVersion : String = UIDevice.current.systemVersion as String //iOS版本
let minorVersion : String = infoDictionary!["CFBundleVersion"] as! String //版本号（内部标示）

typealias FTResponseSuccess = (_ respones : Any) -> Void
typealias FTResponseFail = (_ error : Any) -> Void

class FTAFSessionManager: NSObject
{
    static let shared = FTAFSessionManager()
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
    func get(URLString:String, parameters:Any?,
             success: @escaping FTResponseSuccess,
             failure: @escaping FTResponseFail){
        requesttMethod(method: .GET,
                       URLString: URLString,
                       parameters: parameters,
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
    func post(URLString:String, parameters:Any?,
              success: @escaping FTResponseSuccess,
              failure: @escaping FTResponseFail){
        requesttMethod(method: .POST,
                       URLString: URLString,
                       parameters: parameters,
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
    func postBody(URLString:String, parameters:Any?,
                  success: @escaping FTResponseSuccess,
                  failure: @escaping FTResponseFail){
        requesttMethod(method: .POSTBODY,
                       URLString: URLString,
                       parameters: parameters,
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
    func uploadImage(URLString:String, parameters:Any?,
                  success: @escaping FTResponseSuccess,
                  failure: @escaping FTResponseFail){
        requesttMethod(method: .UPLOAD,
                       URLString: URLString,
                       parameters: parameters,
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
    func requesttMethod(method: HTTPType, URLString:String, parameters:Any?, success: @escaping FTResponseSuccess, failure: @escaping FTResponseFail) {
        if method == .GET {
            getRequest(URLString: URLString, parameters: parameters, success: success, failure: failure)
        }else if method == .POST{
            postRequest(URLString: URLString, parameters: parameters, success: success, failure: failure)
        }else if method == .POSTBODY{
            postBodyRequest(URLString: URLString, parameters: parameters, success: success, failure: failure)
        }else if method == .UPLOAD{
            uploadImage(URLString: URLString, parameters: parameters, success: success, failure: failure)
        }
    }
}


extension FTAFSessionManager
{
    //MARK: - POST
    private func postRequest(URLString:String, parameters:Any?,
                    success: @escaping FTResponseSuccess,
                    failure: @escaping FTResponseFail){
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/json")
        headers.add(name: "Accept-Encoding", value: "gzip")
        headers.add(name: "APPVER", value: majorVersion)
        
        let timestamp = String(format: "\(Int(Date.init().timeIntervalSince1970))")
        let uuid = UUID().uuidString;
        var checkText = String()
        checkText.append("5f2ad63f0ef2")
        checkText.append(uuid)
        checkText.append(timestamp)
        headers.add(name: "CheckSum", value: checkText.sha1())
        headers.add(name: "CurTime", value: timestamp)
        headers.add(name: "Nonce", value: uuid)
        
        headers.add(name: "token", value: "8AlIbdf0MuXDOC9QTbUiPR2FGd23n/vSGJho0MXm1LRoNgOIf2hteGNW+ch5anzGKeKUxG/4CUD8zvqgDYzFsQ==")
        headers.add(name: "MODEL", value: UIDevice.current.modelName)
        headers.add(name: "PL", value: "iOS")
        headers.add(name: "DEVICE", value: NSString.getUUIDByKeyChain())
        
        headers.add(name: "User-Agent", value: String(format: "QingSongCaiJing iOS \(iOSVersion)"))
        headers.add(name: "OS", value: iOSVersion)
        
        headers.add(name: "buildCode", value: minorVersion)
        headers.add(name: "DEVICETOKEN", value: "")
        
        print("POST----URLString : \(URLString) \n---- headers : \(headers) \n---- parameters : \(String(describing: parameters))")
        AF.request(URLString, method: .post, parameters: parameters as? Parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let json = String(data: response.data!, encoding: String.Encoding.utf8)
                let dict =  json?.stringValueDictionary(json!)
                success(dict!)
            case .failure:
                let statusCode = response.response?.statusCode
                print("\(statusCode ?? 0)请求失败")
                debugPrint(response.response as Any)
                failure(response.response?.description ?? "")
            }
        }
    }
    
    //MARK: - POST(BODY)
    private func postBodyRequest(URLString:String, parameters:Any?,
                             success: @escaping FTResponseSuccess,
                             failure: @escaping FTResponseFail){
        let json = JSON.init(parameters as Any)
        let urlReqest = URL.init(string: URLString)
        var request = URLRequest.init(url: urlReqest!)
        request.httpMethod = HTTPMethod.post.rawValue
        
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/json")
        headers.add(name: "Accept-Encoding", value: "gzip")
        headers.add(name: "APPVER", value: majorVersion)
        
        let timestamp = String(format: "\(Int(Date.init().timeIntervalSince1970))")
        let uuid = UUID().uuidString;
        var checkText = String()
        checkText.append("5f2ad63f0ef2")
        checkText.append(uuid)
        checkText.append(timestamp)
        headers.add(name: "CheckSum", value: checkText.sha1())
        headers.add(name: "CurTime", value: timestamp)
        headers.add(name: "Nonce", value: uuid)
        
        headers.add(name: "token", value: "8AlIbdf0MuXDOC9QTbUiPR2FGd23n/vSGJho0MXm1LRoNgOIf2hteGNW+ch5anzGKeKUxG/4CUD8zvqgDYzFsQ==")
        headers.add(name: "MODEL", value: UIDevice.current.modelName)
        headers.add(name: "PL", value: "iOS")
        headers.add(name: "DEVICE", value: NSString.getUUIDByKeyChain())
        
        headers.add(name: "User-Agent", value: String(format: "QingSongCaiJing iOS \(iOSVersion)"))
        headers.add(name: "OS", value: iOSVersion)
        
        headers.add(name: "buildCode", value: minorVersion)
        headers.add(name: "DEVICETOKEN", value: "")
        
        request.headers = headers
        request.httpBody = json.description.data(using: .utf8)
        
        print("GET----URLString : \(URLString) \n---- headers : \(headers) \n---- parameters : \(String(describing: parameters))")
        sessionManager?.request(request).validate().responseJSON{ (response) in
            switch response.result {
            case .success:
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
                success(dict!)
            case .failure:
                let statusCode = response.response?.statusCode
                print("\(statusCode ?? 0)请求失败")
                debugPrint(response.response as Any)
                failure(response.response?.description ?? "")
            }
        }
    }
    
    //MARK: - GET请求
    private func getRequest(URLString:String, parameters:Any?,
                    success: @escaping FTResponseSuccess,
                    failure: @escaping FTResponseFail){
        
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/json")
        headers.add(name: "Accept-Encoding", value: "gzip")
        headers.add(name: "APPVER", value: majorVersion)
        
        let timestamp = String(format: "\(Int(Date.init().timeIntervalSince1970))")
        let uuid = UUID().uuidString;
        var checkText = String()
        checkText.append("5f2ad63f0ef2")
        checkText.append(uuid)
        checkText.append(timestamp)
        headers.add(name: "CheckSum", value: checkText.sha1())
        headers.add(name: "CurTime", value: timestamp)
        headers.add(name: "Nonce", value: uuid)
        
        headers.add(name: "token", value: "8AlIbdf0MuXDOC9QTbUiPR2FGd23n/vSGJho0MXm1LRoNgOIf2hteGNW+ch5anzGKeKUxG/4CUD8zvqgDYzFsQ==")
        headers.add(name: "MODEL", value: UIDevice.current.modelName)
        headers.add(name: "PL", value: "iOS")
        headers.add(name: "DEVICE", value: NSString.getUUIDByKeyChain())
        
        headers.add(name: "User-Agent", value: String(format: "QingSongCaiJing iOS \(iOSVersion)"))
        headers.add(name: "OS", value: iOSVersion)
        
        headers.add(name: "buildCode", value: minorVersion)
        headers.add(name: "DEVICETOKEN", value: "")
        
        print("GET----URLString : \(URLString) \n---- headers : \(headers) \n---- parameters : \(String(describing: parameters))")
        AF.request(URLString, method: .get, parameters: parameters as? Parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ (response) in
            switch response.result {
            case .success:
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
                success(dict!)
            case .failure:
                let statusCode = response.response?.statusCode
                print("\(statusCode ?? 0)请求失败")
                debugPrint(response.response as Any)
                failure(response.response?.description ?? "")
            }
        }
    }
    
    //MARK: - 上传图片
    private func uploadImageRequest(URLString:String, parameters:Any?,
                                    success: @escaping FTResponseSuccess,
                                    failure: @escaping FTResponseFail){
        
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/json")
        headers.add(name: "Accept-Encoding", value: "gzip")
        headers.add(name: "APPVER", value: majorVersion)
        
        let timestamp = String(format: "\(Int(Date.init().timeIntervalSince1970))")
        let uuid = UUID().uuidString;
        var checkText = String()
        checkText.append("5f2ad63f0ef2")
        checkText.append(uuid)
        checkText.append(timestamp)
        headers.add(name: "CheckSum", value: checkText.sha1())
        headers.add(name: "CurTime", value: timestamp)
        headers.add(name: "Nonce", value: uuid)
        
        headers.add(name: "token", value: "8AlIbdf0MuXDOC9QTbUiPR2FGd23n/vSGJho0MXm1LRoNgOIf2hteGNW+ch5anzGKeKUxG/4CUD8zvqgDYzFsQ==")
        headers.add(name: "MODEL", value: UIDevice.current.modelName)
        headers.add(name: "PL", value: "iOS")
        headers.add(name: "DEVICE", value: NSString.getUUIDByKeyChain())
        
        headers.add(name: "User-Agent", value: String(format: "QingSongCaiJing iOS \(iOSVersion)"))
        headers.add(name: "OS", value: iOSVersion)
        
        headers.add(name: "buildCode", value: minorVersion)
        headers.add(name: "DEVICETOKEN", value: "")
        
        print("GET----URLString : \(URLString) \n---- headers : \(headers) \n---- parameters : \(String(describing: parameters))")
        
        let images = parameters as! Array<Any>
        self.sessionManager?.upload(multipartFormData: { (multipartFormData) in
            
            for data in images {
                let dataStr = DateFormatter.init()
                dataStr.dateFormat = "yyyyMMddHHmmss"
                let fileName = "\(dataStr.string(from: Date.init())).png"
                multipartFormData.append(data as! Data, withName: "file", fileName: fileName, mimeType: "image/jpg/png/jpeg")
            }
            
        }, to: URLString, headers: headers).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success:
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
                success(dict!)
            case .failure:
                let statusCode = response.response?.statusCode
                print("\(statusCode ?? 0)请求失败")
                debugPrint(response.response as Any)
                failure(response.response?.description ?? "")
            }
        })
    }
}

//MARK: - UIDevice延展
public extension UIDevice
{
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
     
        switch identifier {
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch (5 Gen)"
        case "iPod7,1":   return "iPod Touch 6"
     
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":   return "iPhone 5"
        case  "iPhone5,2":  return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":  return "iPhone 5c (GSM)"
        case "iPhone5,4":  return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":  return "iPhone 5s (GSM)"
        case "iPhone6,2":  return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone SE"
        case "iPhone9,1":   return "国行、日版、港行iPhone 7"
        case "iPhone9,2":  return "港行、国行iPhone 7 Plus"
        case "iPhone9,3":  return "美版、台版iPhone 7"
        case "iPhone9,4":  return "美版、台版iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":   return "iPhone 8"
        case "iPhone10,2","iPhone10,5":   return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":   return "iPhone X"
        
        case "iPhone11,8": return "iPhone XR"
        case "iPhone11,2": return "iPhone XS"
        case "iPhone11,6","iPhone11,4":   return "iPhone XS Max"
        case "iPhone12,1": return "iPhone 11"
        case "iPhone12,3": return "iPhone 11 Pro"
        case "iPhone12,5": return "iPhone 11 Pro Max"
        
        case "iPad1,1":   return "iPad"
        case "iPad1,2":   return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":   return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":   return "Apple TV 4"
        case "i386", "x86_64":   return "Simulator"
        default:  return identifier
        }
    }
}


extension String {
    
    func stringValueDictionary(_ str:String) -> [String: Any]?
    {
        let data = str.data(using:String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!,options: JSONSerialization.ReadingOptions.mutableContainers)as? [String: Any] {
            return dict
        }
        return nil
    }
    
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
//        result.deinitialize(count: 0)
        return String(format: hash as String)
    }
    
    func sha1() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_SHA1(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
//        result.deinitialize(count: 0)
        return String(format: hash as String)
    }
    
    
    func base64decode() -> String? {
        
        let decodeData:Data? = Data.init(base64Encoded: self, options: Data.Base64DecodingOptions.init(rawValue: 0))
        guard let utf8Data = decodeData else{
            return nil
        }
        
        let decodedStr:String? = String.init(data: utf8Data, encoding: String.Encoding.utf8)
        
        return decodedStr
        
    }
    
    func base64encode() -> String? {
        
        let utf8str:Data? = self.data(using: String.Encoding.utf8)
        guard let utf8Data = utf8str else{
            return nil
        }
        
        let base64Encoded:String = utf8Data.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        return base64Encoded
    }
    
}
