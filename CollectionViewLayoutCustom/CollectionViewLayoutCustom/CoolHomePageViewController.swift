//
//  CoolHomePageViewController.swift
//  CollectionCellAnimationDemo
//
//  Created by 童星 on 2017/1/13.
//  Copyright © 2017年 童星. All rights reserved.
//

import UIKit

class CoolHomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.isNavigationBarHidden = true
        let layout = CoolHomePageLayout()
        let collectionView = MainCollectionView(frame: CGRect(x:0, y:0,width:kScreenWidth, height:kScreenHeight), collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //更新statusbar的颜色
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
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
