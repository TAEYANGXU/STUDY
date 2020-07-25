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
//        File Name:       FTAFHTTPTarget.swift
//        Product Name:    TEAYANGPROJECT
//        Author:          xuyanzhang@上海览益信息科技有限公司
//        Swift Version:   5.0
//        Created Date:    2020/7/24 9:01 AM
//
//        Copyright © 2020 上海览益信息科技有限公司.
//        All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
        

import UIKit
import Alamofire

let infoDictionary = Bundle.main.infoDictionary
let majorVersion :String = infoDictionary!["CFBundleShortVersionString"] as! String//应用版本号
let iOSVersion : String = UIDevice.current.systemVersion as String //iOS版本
let minorVersion : String = infoDictionary!["CFBundleVersion"] as! String //版本号（内部标示）
let HSSecretKey : String = "f9d39537-a9fc-4099-ac88-b2c3105cc81d"
let QZCsecretKey : String = "663f10612c2b2a35e48a3b2e505b459a"

//MARK: - 当前项目有青松、花生、七指禅等服务接入、并且请求验签方式也不同
enum FTServerType
{
    case QS//青松
    case HS//花生
    case QZC//七指禅
}

enum FTHTTPMethod
{
    case GET
    case POST
    case POSTBODY//参数放入body
    case UPLOAD//上传文件
}

struct FTHTTPTarget
{
    var path: String
    var pararms: Any
    var method: FTHTTPMethod
    var serverType: FTServerType
    init(path: String,pararms: Any, method:FTHTTPMethod, serverType: FTServerType) {
        self.path = path
        self.pararms = pararms
        self.method = method
        self.serverType = serverType
    }
}

protocol FTHttpBase {
    
    var baseUrl: String  { get }
    var headers: HTTPHeaders {get}
}

extension FTHTTPTarget : FTHttpBase
{
    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/json")
        headers.add(name: "Accept-Encoding", value: "gzip")
        headers.add(name: "APPVER", value: majorVersion)
        headers.add(name: "PL", value: "iOS")
        headers.add(name: "OS", value: iOSVersion)
        headers.add(name: "MODEL", value: UIDevice.current.modelName)
        headers.add(name: "User-Agent", value: String(format: "QingSongCaiJing iOS \(iOSVersion)"))
        if serverType == .QS
        {
            let timestamp = String(format: "\(Int(Date.init().timeIntervalSince1970))");  let uuid = UUID().uuidString;
            var checkText = String();  checkText.append("5f2ad63f0ef2");  checkText.append(uuid);  checkText.append(timestamp)
            headers.add(name: "CheckSum", value: checkText.sha1())
            headers.add(name: "CurTime", value: timestamp)
            headers.add(name: "Nonce", value: uuid)
            headers.add(name: "DEVICE", value: NSString.getUUIDByKeyChain())
            headers.add(name: "buildCode", value: minorVersion)
            headers.add(name: "DEVICETOKEN", value: "")
            headers.add(name: "token", value: "8AlIbdf0MuXDOC9QTbUiPR2FGd23n/vSGJho0MXm1LRoNgOIf2hteGNW+ch5anzGGAHOshI8+yBehTnMAtNkdQ==")
        }
        if serverType == .HS
        {
            let timestamp = String(format: "\(Int(Date.init().timeIntervalSince1970))");
            headers.add(name: "TIMESTAMP", value: timestamp)
            let text = String(format: "APPVER=%@&PL=%@&TIMESTAMP=%@%@", majorVersion,"iOS",timestamp,HSSecretKey)
            headers.add(name: "SIGN", value: text.md5())
            headers.add(name: "CHANNEL", value: "zeus_ios")
            headers.add(name: "PROJECT", value: "29")
            headers.add(name: "TOKEN", value: "8AlIbdf0MuXDOC9QTbUiPR2FGd23n/vSGJho0MXm1LRoNgOIf2hteGNW+ch5anzGGAHOshI8+yBehTnMAtNkdQ==")
        }
        if serverType == .QZC {
            let timestamp = String(format: "\(Int(Date.init().timeIntervalSince1970))");
            let text = String(format: "APPVER=%@&PL=%@&TIMESTAMP=%@%@", majorVersion,"iOS",timestamp,QZCsecretKey)
            headers.add(name: "SIGN", value: text.md5())
            headers.add(name: "TIMESTAMP", value: timestamp)
            headers.add(name: "DEVICE", value: "dfae2fe2d4fa74966869a9180eae5bf54cdcead1d1ed80aa7b161aae6d3e88ec")
            headers.add(name: "SVTYPE", value: "UM")
            headers.add(name: "CHANNEL", value: "zeus_ios")
            headers.add(name: "IMEI", value: UIDevice.current.modelName)
            headers.add(name: "TOKEN", value: "tLimOUAXYbEhuuzpTY3gKGRlYWRlN2RlYjhjYWMyNDgzODQ5NGMwMGM4OTJmNzEzMGNiODE0YzM1NTI4ZDk2ZjQ3ZjExNTFhZWMyNTg5YjTDuJhOpiVCVOu7hI3W57aKkCvzkSpXLL1Ro1pr7Y04ICsAeLZhQ7GJTehRNhH7Tc8yq0qUOkyAeQhuA4lR9Czq2YjFoylXSPh2xA/h/WUMqw==")
            headers.add(name: "NET", value: "WIFI")
            headers.add(name: "SVTOKEN", value: "dfae2fe2d4fa74966869a9180eae5bf54cdcead1d1ed80aa7b161aae6d3e88ec")
        }
        return headers
    }
    
    var baseUrl: String {
        var url: String = ""
        if serverType == .QS {
            url = "http://zeus-api-test.qingsongfe.com:58080"
        }
        if serverType == .HS
        {
            url = "http://live-api-test.qingsongfe.com"
        }
        if serverType == .QZC {
            url = "http://139.224.196.167:13223"
        }
        return url
    }
}
