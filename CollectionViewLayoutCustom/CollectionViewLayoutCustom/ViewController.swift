//
//  ViewController.swift
//  CollectionViewLayoutCustom
//
//  Created by 童星 on 2017/1/16.
//  Copyright © 2017年 童星. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableview: UITableView = {
        
        let tableview:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), style: .plain)
        tableview.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableview.rowHeight = 44
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        
        return tableview
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "首页"
        view.addSubview(tableview)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "demo\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            pushVC(vc: NormalCellAnimation())
        }else{
            
            pushVC(vc: CoolHomePageViewController())
        }
    }
}

