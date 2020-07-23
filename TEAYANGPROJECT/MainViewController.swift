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
//        File Name:       MainViewController.swift
//        Product Name:    TEAYANGPROJECT
//        Author:          xuyanzhang@上海览益信息科技有限公司
//        Swift Version:   5.0
//        Created Date:    2020/7/22 11:10 AM
//
//        Copyright © 2020 上海览益信息科技有限公司.
//        All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
        

import UIKit

class MainViewController: UITabBarController
{

    var vcOne : OneViewController = {
        let vc = OneViewController()
        vc.view.backgroundColor = .white
        return vc
    }()
    var vcTwo : UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        return vc
    }()
    var vcThree : UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .yellow
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
     
    private func setUpUI(){
        
//        [UINavigationBar appearance].translucent = NO;
        UINavigationBar.appearance().isTranslucent = false
        
        vcOne.tabBarItem = UITabBarItem(title: "测试", image: UIImage(named: "tab_icon_off_01")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "tab_icon_on_01")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        vcOne.title = "测试"
        let navOne = UINavigationController(rootViewController: vcOne)
        addChild(navOne)
        
        vcTwo.tabBarItem = UITabBarItem(title: "测试", image: UIImage(named: "tab_icon_off_01")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "tab_icon_on_01")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        vcTwo.title = "测试"
        let navTwo = UINavigationController(rootViewController: vcTwo)
        addChild(navTwo)
        
        vcThree.tabBarItem = UITabBarItem(title: "测试", image: UIImage(named: "tab_icon_off_01")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "tab_icon_on_01")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        vcThree.title = "测试"
        let navThree = UINavigationController(rootViewController: vcThree)
        addChild(navThree)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
