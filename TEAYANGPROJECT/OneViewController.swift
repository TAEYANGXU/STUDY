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
//        File Name:       OneViewController.swift
//        Product Name:    TEAYANGPROJECT
//        Author:          xuyanzhang@上海览益信息科技有限公司
//        Swift Version:   5.0
//        Created Date:    2020/7/22 2:35 PM
//
//        Copyright © 2020 上海览益信息科技有限公司.
//        All rights reserved.
// )                                                                  (
//'--------------------------------------------------------------------'
        

import UIKit
@_exported import SnapKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON
import ObjectMapper

class OneViewController: UIViewController {

    let button : UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .red
        btn.setTitle("哈哈哈哈", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    let textFiled : UITextField = {
        let text = UITextField()
        text.backgroundColor = .red
        return text
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        view.addSubview(button)
//        button.snp.makeConstraints { (make) in
//            make.top.equalTo(50)
//            make.size.equalTo(CGSize(width: 120, height: 50))
//            make.centerX.equalTo(view.snp_centerX)
//        }
//
//        view.addSubview(textFiled)
//        textFiled.snp.makeConstraints { (make) in
//            make.top.equalTo(button.snp_bottom).offset(40)
//            make.size.equalTo(CGSize(width: 200, height: 50))
//            make.centerX.equalTo(view.snp_centerX)
//        }
//
//
//        button.rx.tap.subscribe(onNext: { [weak self] in
//            print("点击了")
//            self?.button.backgroundColor = .yellow
//        }).disposed(by: disposeBag)
//
//        textFiled.rx.text.orEmpty.changed.subscribe(onNext: {(text) in
//                print("text = \(text)")
//            }).disposed(by: disposeBag)
//
//        textFiled.rx.text.bind(to: button.rx.title()).disposed(by: disposeBag)
        
//        FTAFHTTPSessionManager.shared.postBody(target: FTHTTPTarget(path: "/api/v1/contract/Remove", pararms: [["id":"105"]], method: .POSTBODY, serverType: .QS), success: { (data) in
//
//        }) { (error) in
//
//        }
//        FTAFHTTPSessionManager.shared.get(target: FTHTTPTarget(path: "/api/v1/user/Get", pararms: [], method: .GET, serverType: .QS), success: { (data) in
//
//        }) { (error) in
//
//        }
        
        FTAFHTTPSessionManager.shared.get(target: FTHTTPTarget(path: "/v3/video/get-recomends", pararms: [], method: .GET, serverType: .HS), success: { (model,data) in
            let array:Array = model.data as! Array<Any>
            let list : Array<FTRecomendsModel> = Mapper<FTRecomendsModel>().mapArray(JSONObject: array)!
            for model in list {
                print("\(String(describing: model.act?.actName))")
            }
        }) { (error) in
            debugPrint("\(String(describing: error.errorMsg))")
        }
        
        
//        FTAFHTTPSessionManager.shared.get(URLString: "http://zeus-api-test.qingsongfe.com:58080/api/v1/notification/GetUnreadCounts", parameters: ["TradeToken":""], success: { (data) in
//            
//        }) { (error) in
//            
//        }
        
        
//        http://zeus-api-test.qingsongfe.com:58080/api/v1/notification/GetUnreadCounts?TradeToken=
//        FTAFSessionManager.shared.get(URLString: "http://zeus-api-test.qingsongfe.com:58080/api/v1/user/Get", parameters: ["":""], success: { (data) in
//
//            let dict = data as! Dictionary<String, Any>
//            let dataDict = dict["data"] as? [String : Any]
//            if dataDict == nil {
//                print("NULL")
//            }else{
//                let model = Mapper<FTUserInfoModel>().map(JSON: dict["data"] as! [String : Any])
//                print("nickname = \(model?.nickname)")
//            }
//        }) { (error) in
//
//        }
//        FTAFSessionManager.shared.get(URLString: "http://zeus-api-test.qingsongfe.com:58080/api/v1/user/Get", parameters: ["":""], success: { (response) in
//
////            let dict = JSON(response).dictionary! as Dictionary<String, Any>
//            let dict = try JSON(data: response)
//
//        }) { (error) in
//
//        }
        
//        AF.request("", method: .get, parameters: ["":""], encoder: nil, headers: HTTPHeader(name: "", value: ""), interceptor: RequestInterceptor?) { (request) in
//            
//        }
//        let emtyOb = Observable<Int>.empty()
//        _ = emtyOb.subscribe(onNext: {(number) in
//            print("订阅:",number)
//        }, onError: {(error) in
//            print("error:",error)
//        }, onCompleted: {
//            print("完成回调")
//        }){
//            print("释放回调")
//        }
//
//        Observable.range(start: 2, count: 5)
//        .subscribe { (event) in
//            print(event)
//        }.disposed(by: disposeBag)
        
        
//        Alamofire.Request.
        
//        TEST { (model, json) in
//            
//        }
        
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
