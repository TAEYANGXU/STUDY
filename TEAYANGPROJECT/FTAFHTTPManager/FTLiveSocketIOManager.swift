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
//        File Name:       FTLiveSocketIOManager.swift
//        Product Name:    TEAYANGPROJECT
//        Author:          xuyanzhang@上海览益信息科技有限公司
//        Swift Version:   5.0
//        Created Date:    2020/8/7 1:28 PM
//
//        Copyright © 2020 上海览益信息科技有限公司.
//        All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
        

import UIKit
import SocketIO

let EMIT_CONNECT : String    = "connect"
let EMIT_CONNECTING : String = "connecting"
let EMIT_DISCONNECT : String = "disconnect"

typealias FTIOResponse = (_ response : Any) -> Void

class FTLiveSocketIOManager: NSObject {

    static let shared = FTLiveSocketIOManager()
    private var socketManager: SocketManager?
    private var socketIOClient: SocketIOClient?
    private var wsRoom: String = ""
    
    @objc open func socketIOWithURL(url:String, wsRoom:String, callback: @escaping FTIOResponse)
    {
        self.wsRoom = wsRoom;
        socketManager = SocketManager(socketURL: URL(string: url)!, config: [.forceWebsockets(true), .reconnects(true), .log(true)])
        socketIOClient = socketManager?.defaultSocket
        let _ = socketManager?.socket(forNamespace: "/socket.io/")
        onEvents(response: callback)
        onConnect(response: callback,wsRoom: wsRoom)
        onConnecting(response: callback)
        onDisConnect(response: callback)
        socketIOClient?.connect()
    }
    @objc open func socketIOClose()
    {
        if socketIOClient != nil {
            socketIOClient?.off(EMIT_CONNECT)
            socketIOClient?.off(EMIT_CONNECTING)
            socketIOClient?.off(EMIT_DISCONNECT)
            socketIOClient?.off("commonMessage")
            socketIOClient?.off("ensureMessage")
            socketIOClient?.emit("leaveRoom", wsRoom)
        }
    }
}

extension FTLiveSocketIOManager
{
    private func onConnect(response: @escaping FTIOResponse, wsRoom:String)
    {
        socketIOClient?.on(EMIT_CONNECT, callback: { [weak self] (data, ask) in
            print("socket connected")
            self?.socketIOClient?.emit("joinRoom", wsRoom)
        })
    }
    private func onConnecting(response: @escaping FTIOResponse)
    {
        socketIOClient?.on(EMIT_CONNECTING, callback: { (data, ask) in
            print("socket connecting")
        })
    }
    private func onDisConnect(response: @escaping FTIOResponse)
    {
        socketIOClient?.on(EMIT_DISCONNECT, callback: { (data, ask) in
            print("socket disconnect")
        })
    }
    private func onEvents(response: @escaping FTIOResponse)
    {
        socketIOClient?.on("commonMessage", callback: { [weak self] (data, ask) in
            print("commonMessage")
            print("data : \(data)")
            if data.count > 0 {
                let dict : NSDictionary? = self?.jsonToDictionary(json: data[0] as! String)
                response(dict as Any)
            }
        })
        socketIOClient?.on("ensureMessage", callback: { [weak self] (data, ask) in
            print("ensureMessage")
            print("data : \(data)")
            if data.count > 0 {
                let dict : NSDictionary? = self?.jsonToDictionary(json: data[0] as! String)
                let isEnsure = dict!["isEnsure"] as! Bool
                let msgId = dict!["isEnsure"] as! String
                if isEnsure {
                    self?.socketIOClient?.emit("confirmMessage", msgId)
                }
                response(dict as Any)
            }
        })
    }
    
    private func jsonToDictionary(json:String) -> NSDictionary
    {
        let jsonData:Data = json.data(using: String.Encoding.utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? NSDictionary
        print("postData : \(String(describing: dict?["postData"]))")
        return dict!
    }
}
