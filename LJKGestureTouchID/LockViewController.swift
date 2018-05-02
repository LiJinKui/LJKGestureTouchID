//
//  LockViewController.swift
//  LJKPopShowView
//
//  Created by 李金奎 on 2018/4/25.
//  Copyright © 2018年 李金奎. All rights reserved.
//

import UIKit

class LockViewController: UIViewController {

    var selectedIDs:Array<Any>!
    lazy var gesturesView: GestureBlockView = {
        let itemWidth: CGFloat = ScreenW - 80
        let gesturesV = GestureBlockView.init(frame: CGRect(x: 40, y: ScreenH/2 - itemWidth/2, width: itemWidth, height: itemWidth))
        gesturesV.backgroundColor = UIColor.clear
        gesturesV.settingGesture = false
        // 防止循环引用
        weak var WeakSelf = self
        //设置手势，记录设置的密码，待确定后确定
        gesturesV.gestureBlock = {(selectedIDs: Array<Any>) in
            WeakSelf?.selectedIDs = selectedIDs
            print("密码： ")
            for item in selectedIDs{
                print("<\(item)>\n")
            } 
        }
        //判断解锁状态
        gesturesV.unlockBlock = {(isSuccess: Bool) in
            if isSuccess{
                print("解锁成功")
            }else{
                print("解锁失败")
            }
        }
        // 设置失败
        gesturesV.settingBlock = {()in
            print("手势密码不得少于4个点")
        }
        return gesturesV
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "手势密码"
        view.backgroundColor = UIColor.black
        view.addSubview(gesturesView)
        // Do any additional setup after loading the view.
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
