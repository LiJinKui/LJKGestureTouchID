//
//  ViewController.swift
//  LJKGestureTouchID
//
//  Created by 李金奎 on 2018/4/28.
//  Copyright © 2018年 李金奎. All rights reserved.
//

import UIKit
// 设备屏幕宽
public let ScreenW = UIScreen.main.bounds.width
// 设备屏幕高
public let ScreenH = UIScreen.main.bounds.height
public let MENUS_COLORS = [UIColor.red, UIColor.orange, UIColor.blue, UIColor.brown]
class ViewController: UIViewController {
// 按钮数组
    var btnList = ["指纹解锁", "手势解锁"]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0.95, alpha: 1.0)
        for i in 0...(btnList.count - 1){
            let initBtn = UIButton.init(type: .custom)
            initBtn.frame = CGRect(x: 20, y: 88 + i*(35 + 10), width: Int(ScreenW * 0.4), height: 35)
            initBtn.tag = i
            initBtn.layer.cornerRadius = 3
            initBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            initBtn.setTitle(btnList[i], for: .normal)
            initBtn.backgroundColor = MENUS_COLORS[i]
            initBtn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
            view.addSubview(initBtn)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    @objc func btnClick(_ sender: UIButton){
        if sender.tag == 0 {
            // 判断是否开启 指纹识别
            let isCanOpenStr: String = String.init(format: "\(String(describing: UserDefaults.standard.object(forKey: "OpenTouchID")))")
            if (isCanOpenStr == "nil") || (isCanOpenStr.isEmpty) {
                DispatchQueue.main.async {
                    let alertController = UIAlertController.init(title: "温馨提示", message: "是否开启TouchID", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction.init(title: "YES", style: .default, handler: { (action) in
                        // 开启 TouchID
                        UserDefaults.standard.setValue(true, forKey: "OpenTouchID")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenTouchIDSuccess"), object: nil, userInfo: nil)
                        self.navigationController?.pushViewController(TouchIDController(), animated: true)
                    }))
                    alertController.addAction(UIAlertAction.init(title: "NO", style: .cancel, handler: { (action) in
                        // 不开启 TouchID
                        UserDefaults.standard.setValue(false, forKey: "OpenTouchID")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenTouchIDSuccess"), object: nil, userInfo: nil)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            }else{
                self.navigationController?.pushViewController(TouchIDController(), animated: true)
            }
        } else {
            self.navigationController?.pushViewController(LockViewController(), animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

