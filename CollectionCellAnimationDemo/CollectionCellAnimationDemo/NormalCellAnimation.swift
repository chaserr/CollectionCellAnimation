//
//  NormalCellAnimation.swift
//  CollectionCellAnimationDemo
//
//  Created by 童星 on 2017/1/13.
//  Copyright © 2017年 童星. All rights reserved.
//

import UIKit
enum PullType {
    case `default`
    case up
    case down
}
let collectionCellID = "CollectionCell"
let kMaxDuration = 4.0
let kMaxRadius: CGFloat = 80.0

class NormalCellAnimation: UIViewController {

    var pageIndex: Int = 1
    var pageSize = 20
    var loadMoreTimer: Timer?
    lazy var userDataArray: [Any]? = {
        
        let array: Array = [Any]()
        return array
    }()
    
    fileprivate var contentOffsetY: CGFloat = 0.0
    fileprivate var oldContentOffSetY: CGFloat = 0.0
    fileprivate var newContentOffSetY: CGFloat = 0.0
    
    fileprivate var collectionView: UICollectionView?
    fileprivate var isPullUp: Bool?
    fileprivate var pullType: PullType = .default
    lazy fileprivate var currentDataArray: [Any]? = {
        
        let array: Array = [Any]()
        return array
    }()
    fileprivate var lastItemY: CGFloat?
    fileprivate var pulseLayer: PulsingLayer?
    fileprivate var animationImgView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        refreshData()
        
    }
    
    fileprivate func setupLayout() {
        let layout = CollectionLayout()
        layout.delegate = self
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height), collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.init(red: 0.9215, green: 0.9215, blue: 0.9215, alpha: 1.0)
        view.addSubview(collectionView!)
        
        collectionView?.register(UINib.init(nibName: "DynamicCell", bundle: nil), forCellWithReuseIdentifier: collectionCellID)
        
    }
    
    fileprivate func loadMoreData() {
        pageIndex = pageIndex + 1
        if pageIndex * pageSize > (userDataArray?.count)! {
            // 停止加载更多数据
        }else{
            
            var tmpArray: [Any] = []
            
            let count = pageIndex * pageSize
            
            for (idx, obj) in (userDataArray?.enumerated())! {
                if idx > (pageIndex - 1) * pageSize {
                    tmpArray.append(obj)
                }
                if idx == count {
                    break
                }
            }
            
            currentDataArray?.append(contentsOf: tmpArray)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: UInt64(2.0)), execute: {
                self.collectionView?.reloadData()
                
            })
        }
        
        
    }
    
    fileprivate func loadNewData() {
        
        refreshData()
    }
    
    fileprivate func refreshData() {
        
        lastItemY = 0
        pageIndex = 1
        currentDataArray?.removeAll()
        userDataArray?.removeAll()
        
        for _ in 0..<200 { // 初始化一百条数据
            let userModel: UserModel = UserModel()
            userDataArray!.append(userModel)
        }
        
        let count = pageIndex * pageSize
        for (idx, obj) in (userDataArray?.enumerated())! {
            currentDataArray?.append(obj)
            if idx == count {
                break
            }
        }
        
        collectionView?.reloadData()
        
    }
    
    func resumePulseAnimation() {
        self.collectionView?.reloadData()
    }
    
    func suspendPulseAnimation()  {
        pulseLayer = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension NormalCellAnimation: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (currentDataArray?.count)! + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DynamicCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellID, for: indexPath) as! DynamicCell
        cell.updateContent(contentDict: [:], withVC: self, withIndexPath: indexPath)
        
        let finalCellFrame = cell.frame
        switch pullType {
        case .default: break
        case .up:
            if lastItemY! <= finalCellFrame.origin.y {
                cell.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1)
                UIView.animate(withDuration: 1.5, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: nil)
                
                cell.frame = CGRect.init(x: finalCellFrame.origin.x, y: finalCellFrame.origin.y + 500, width: finalCellFrame.size.width, height: finalCellFrame.size.height)
            }
            
        case .down: break
        }
        
        UIView.animate(withDuration: 1.0) {
            cell.frame = finalCellFrame
        }
        
        // 记录最后一个item的Y值
        if cell.frame.origin.y > lastItemY! {
            lastItemY = cell.frame.origin.y
        }
        if indexPath.item == 1 {
            startPulsAnimationWithCell(cell: cell)
        }
        
        
        return cell
        
        
    }
    
    
    func startPulsAnimationWithCell(cell: DynamicCell) {
        if pulseLayer == nil {
            let layer: PulsingLayer = PulsingLayer()
            layer.animationDuration = 1*kMaxDuration
            layer.radius = 1*kMaxRadius
            layer.haloLayerNumber = 4
            layer.backgroundColor = UIColor.init(red: 0.8617, green: 0.0, blue: 0.3063, alpha: 0.15).cgColor
            let centerPoint = CGPoint.init(x: cell.center.x, y: cell.center.y - 10)
            layer.position = centerPoint
            layer.zPosition = -1
            self.pulseLayer = layer
            collectionView?.layer.insertSublayer(self.pulseLayer!, below: cell.layer)
            self.pulseLayer?.start()
            
            
        }
    }
}

extension NormalCellAnimation: UIScrollViewDelegate{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.panGestureRecognizer.state == UIGestureRecognizerState.ended { // 手松开
            let translation: CGPoint = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            if translation.y > 0  {
                pullType = .up
            }else{
                
                pullType = .down
            }
            
        }
        
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
            UIView.animate(withDuration: 1.0, animations: {
                self.collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
            }, completion: { (Bool) in
                self.pageIndex += 1
                let preCount = self.pageIndex - 1 * self.pageSize
                let count = self.pageIndex * self.pageSize
                for (idx, obj) in (self.userDataArray?.enumerated())! {
                    if idx > preCount {
                        
                        self.currentDataArray?.append(obj)
                    }
                    if idx == count {
                        break
                    }
                }
                self.collectionView?.reloadData()
                
            })
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        newContentOffSetY = scrollView.contentOffset.y
        if newContentOffSetY >= oldContentOffSetY && oldContentOffSetY >= contentOffsetY { // 向上滚动
            
            pullType = .up
            
        }else if (newContentOffSetY < oldContentOffSetY && oldContentOffSetY < contentOffsetY) { // 向下滚动
            pullType = .down
        }else{
            
            pullType = .up
        }
        
        if scrollView.isDragging { // 拖拽
            if scrollView.contentOffset.y - contentOffsetY > 5.0 { // 向上拖拽
                pullType = .up
            } else if contentOffsetY - scrollView.contentOffset.y > 5.0 { // 向下拖拽
                pullType = .down
            }else{
                
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        contentOffsetY = scrollView.contentOffset.y
    }
    
    
}

extension NormalCellAnimation: CollectionLayoutDelegate {
    
    func waterFlowLayout(layout: CollectionLayout, index heightForItemAtIndex: Int, itemWidth: Float) -> Float {
        return 130
    }
    
    func columnCountInWaterFlowLayout(layout: CollectionLayout) -> Int {
        return 3
    }
    
    func rowMarginInWaterFlowLayout(layout: CollectionLayout) -> Float {
        return 20
    }
    
    func itemEdgeInsetInWaterFlowLayout(layout: CollectionLayout) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
}
