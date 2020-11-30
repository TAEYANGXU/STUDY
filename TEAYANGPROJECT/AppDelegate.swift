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
//        File Name:       AppDelegate.swift
//        Product Name:    
//        Author:          xuyanzhang@上海览益信息科技有限公司
//        Swift Version:   5.0
//        Created Date:    2020/7/22 10:53 AM
//
//        Copyright © 2020 上海览益信息科技有限公司.
//        All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
        

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

//    var window: UIWindow = {
//        let windw = UIWindow(frame: UIScreen.main.bounds)
//        return windw
//    }()
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        let mainQ = DispatchQueue.main
//        mainQ.async {
//            print("-----------1")
//        }
//        mainQ.async {
//            sleep(10)
//            print("-----------2")
//        }
//        mainQ.async {
//            print("-----------3")
//        }
//        print("-----------4")
//
//        let queue = DispatchQueue(label: "com.custom.thread", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent)
//        queue.async {
//            print("-----------1")
//        }
//        queue.async {
//            print("-----------2")
//        }
//        queue.async {
//            sleep(4)
//            print("-----------3")
//        }
//        queue.async {
//            print("-----------4")
//        }
//        let queue = DispatchQueue(label: "com.custom.thread", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent)
//        let group = DispatchGroup()
//        queue.async(group: group) {
//            print("-----------1")
//        }
//        queue.async(group: group) {
//            print("-----------2")
//        }
//        queue.async(group: group) {
//            sleep(4)
//            print("-----------3")
//        }
//        queue.async(group: group) {
//            print("-----------4")
//        }
//        group.notify(queue: queue) {
//            print("执行完毕")
//        }
        
        window?.rootViewController = MainViewController();
        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

