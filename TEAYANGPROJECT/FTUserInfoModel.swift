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
//        File Name:       FTUserInfoModel.swift
//        Product Name:    TEAYANGPROJECT
//        Author:          xuyanzhang@上海览益信息科技有限公司
//        Swift Version:   5.0
//        Created Date:    2020/7/23 3:15 PM
//
//        Copyright © 2020 上海览益信息科技有限公司.
//        All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
        

import UIKit
import ObjectMapper

struct FTUserInfoModel: Mappable {
    
    var nickname: String?
    var username: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        username <- map["username"]
        nickname <- map["nickname"]
    }
}

struct FTRecomendsModel: Mappable {
    
    var act: FTActModel?
    var video: FTVideoModel?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        act <- map["act"]
        video <- map["video"]
    }
}

struct FTActModel: Mappable {
    
    var actName: String?
    var des: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        actName <- map["actName"]
        des <- map["des"]
    }
}


struct FTVideoModel: Mappable {
    
    var vTitle: String?
    var vContent: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        vTitle <- map["vTitle"]
        vContent <- map["vContent"]
    }
}
