//
//  TouchIDController.swift
//  LJKPopShowView
//
//  Created by 李金奎 on 2018/4/25.
//  Copyright © 2018年 李金奎. All rights reserved.
//

import UIKit
import LocalAuthentication
class TouchIDController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0.95, alpha: 1.0)
        self.title = "TouchID密码"
        view.addSubview(fgpImg)
        // 判断是否开启 指纹识别
        let isCanOpen: Bool = UserDefaults.standard.bool(forKey: "OpenTouchID")
        if isCanOpen {
            executionTouchID()
        }else{
            canNotOpenTouchID()
        }
        // Do any additional setup after loading the view.
    }
    lazy var fgpImg: UIImageView = {
        let initImg = UIImageView.init(frame: CGRect(x: ScreenW/2 - 40, y: ScreenH/2 - 40, width: 80, height: 80))
        initImg.image = #imageLiteral(resourceName: "指纹解锁.png")
        return initImg
    }()
    func executionTouchID(){
        DispatchQueue.main.async {
            let context: LAContext = LAContext.init()
            var errors: NSError? = nil
            if(context.canEvaluatePolicy(LAPolicy(rawValue: LAPolicy.RawValue(kLAPolicyDeviceOwnerAuthenticationWithBiometrics))!, error: &errors)){
                context.evaluatePolicy(LAPolicy(rawValue: LAPolicy.RawValue(kLAPolicyDeviceOwnerAuthenticationWithBiometrics))!, localizedReason: "TouchID Text", reply: { (success, err) in
                    if (success){// 指纹验证成功
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UnlockLoginSuccess"), object: nil, userInfo: nil)
                        print("指纹验证成功")
                    }else{// 指纹验证失败
                        let error: NSError = err! as NSError
                        switch error.code{
                        case Int(kLAErrorAuthenticationFailed): do {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "touchIDFailed"), object: nil, userInfo: nil)
                            }
                        case Int(kLAErrorUserCancel): do{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "用户取消验证Touch ID"), object: nil, userInfo: nil)
                            self.dismiss(animated: true, completion: nil)
                            }
                        case Int(kLAErrorUserFallback): do{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "touchIDFailed"), object: nil, userInfo: nil)
                            print("用户选择输入密码，切换主线程处理")
                            //                             在TouchID对话框中点击了输入密码按钮
                            }
                        case Int(kLAErrorSystemCancel): do{
                            print("取消授权，如其他应用切入，用户自主")
                            }
                        case Int(kLAErrorPasscodeNotSet): do{
                            print("设备系统未设置密码")
                            }
                        case Int(kLAErrorBiometryNotAvailable): do{
                            print("设备未设置Touch ID")
                            }
                        case Int(kLAErrorBiometryNotEnrolled): do{
                            print("用户未录入指纹")
                            }
                        default:
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "其他情况，切换主线程处理"), object: nil, userInfo: nil)
                        }
                    }})
                
            }else{
                let alertController = UIAlertController.init(title: "温馨提示", message: "该设备不支持TouchID", preferredStyle: .alert)
                alertController.addAction(UIAlertAction.init(title: "完成", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    func canNotOpenTouchID(){
        let alertController = UIAlertController.init(title: "温馨提示", message: "是否开启TouchID", preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "YES", style: .default, handler: { (action) in
            // 开启 TouchID
            UserDefaults.standard.setValue(true, forKey: "OpenTouchID")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenTouchIDSuccess"), object: nil, userInfo: nil)
        }))
        alertController.addAction(UIAlertAction.init(title: "NO", style: .cancel, handler: { (action) in
            // 不开启 TouchID
            UserDefaults.standard.setValue(false, forKey: "OpenTouchID")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenTouchIDSuccess"), object: nil, userInfo: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
