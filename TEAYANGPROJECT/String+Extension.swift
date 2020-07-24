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
//        File Name:       String+Encrypt.swift
//        Product Name:    TEAYANGPROJECT
//        Author:          xuyanzhang@上海览益信息科技有限公司
//        Swift Version:   5.0
//        Created Date:    2020/7/24 9:48 AM
//
//        Copyright © 2020 上海览益信息科技有限公司.
//        All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
        

import Foundation

public extension String
{
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


extension String
{
    func stringValueDictionary(_ str:String) -> [String: Any]?
    {
        let data = str.data(using:String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!,options: JSONSerialization.ReadingOptions.mutableContainers)as? [String: Any] {
            return dict
        }
        return nil
    }
}
