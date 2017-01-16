//
//  CollectionLayout.swift
//  DynamicCollectionCellExample
//
//  Created by 童星 on 2016/11/2.
//  Copyright © 2016年 童星. All rights reserved.
//

import UIKit

let BDefaultColumnMargin: CGFloat = 10.0
let BDefaultRowMargin: CGFloat = 10.0
let BDefaultEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
let BDefaultColumnCount: Int = 3
let itemSizeW: Int = 90


@objc protocol CollectionLayoutDelegate: NSObjectProtocol {
    
    
    /// cell的高度
    ///
    /// - parameter layout:               FlowLayout
    /// - parameter heightForItemAtIndex: 某一个cell
    /// - parameter itemWidth:            cell的宽度
    ///
    /// - returns: cell高度
    
    func waterFlowLayout(layout: CollectionLayout,  index heightForItemAtIndex: Int, itemWidth: Float) -> Float
    
    /// 瀑布流的行数
    @objc optional func columnCountInWaterFlowLayout(layout: CollectionLayout) -> Int
    
    /// 每一列之间的间距
    @objc optional func columnMarginInWaterFlowLayout(layout: CollectionLayout) -> CGFloat
    
    /// 每一行之间的间距
    @objc optional func rowMarginInWaterFlowLayout(layout: CollectionLayout) -> Float
    
    /// item边缘的间距
    @objc optional func itemEdgeInsetInWaterFlowLayout(layout: CollectionLayout) -> UIEdgeInsets
}


class CollectionLayout: UICollectionViewLayout {

    var delegate: CollectionLayoutDelegate?
    fileprivate var bounceFactor: Float?
    /// 存放所有cell的布局属性
    lazy fileprivate var attrsArray: [UICollectionViewLayoutAttributes]? = {
    
        let array: Array = [UICollectionViewLayoutAttributes]()
        return array
    }()
    /// 存放所有列的当前高度
    lazy fileprivate var columnHeights: [CGFloat]? = {
    
        let array: Array = [CGFloat]()
        return array
    }()
    /// 内容高度
    fileprivate var contentHeight: CGFloat?
    
    
    /// 初始化
    ///
    /// - returns: item

    override func prepare() {
        super.prepare()
        contentHeight = 0
        
        columnHeights?.removeAll()
        attrsArray?.removeAll()
        
        for _ in 0..<columnCount() {
            columnHeights?.append(edgeInsets().top)
        }
        
        
        
        let count: Int = (collectionView?.numberOfItems(inSection: 0))!
        for i in 0..<count {
            let indexPath = IndexPath(item: i, section: 0)
            let attrs: UICollectionViewLayoutAttributes = layoutAttributesForItem(at: indexPath)!
            attrsArray?.append(attrs)
            
        }
        
        
    }
    
    
    /// Cell布局
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        _ = collectionView?.frame.size.width
        var w: CGFloat!
        if indexPath.item == 1 {
            w = 90
        }else{
            w = 90
        }
        
        let h = delegate?.waterFlowLayout(layout: self, index: indexPath.item, itemWidth: Float(w!))
        var destColumn = 0
        var minColumnH = columnHeights![0]
        for i in 1..<columnCount() {
            let columnH = columnHeights![i]
            if minColumnH > columnH {
                minColumnH = columnH
                destColumn = i
            }
        }
        
        var y: CGFloat = CGFloat(minColumnH)
        var x: CGFloat = 0
        x = (edgeInsets().left) + CGFloat(destColumn * Int(w + columnMargin()))
        
        if indexPath.item == 1 {
            y = 10.0
        }else if (indexPath.item == 0 || indexPath.item == 2){
        
            y = 50.0
        }else{
        
            if y != rowMargin() {
                y = y + rowMargin()
            }
        }
        
        attrs.frame = CGRect.init(x: x, y: y, width: w, height: CGFloat(h!))
        if indexPath.item == 1 {
            attrs.transform = CGAffineTransform.init(scaleX: 0.65, y: 0.65)
        }else{
        
            attrs.transform = CGAffineTransform.identity
        }
        
        // 更新最短那列高度
        columnHeights?[destColumn] = (attrs.frame.maxY)
        
        let columnHeight: CGFloat = columnHeights![destColumn]
        if contentHeight! < columnHeight {
            contentHeight = columnHeight as CGFloat?
        }
        
        return attrs
        
    }
    
    override var collectionViewContentSize: CGSize{
    
        return CGSize.init(width: 0, height: contentHeight! + edgeInsets().bottom)
    }
    
    func rowMargin() -> CGFloat {
        if (delegate?.responds(to: #selector(delegate?.rowMarginInWaterFlowLayout(layout:))))!{
            return CGFloat((delegate?.rowMarginInWaterFlowLayout!(layout: self))!)
        }else{
        
            return BDefaultRowMargin
        }
    }
    
    func columnMargin() -> CGFloat {
        if (delegate?.responds(to: #selector(delegate?.columnMarginInWaterFlowLayout(layout:))))!{
            return (delegate?.columnMarginInWaterFlowLayout!(layout: self))!
        }else{

            return (((collectionView?.frame.size.width)! - edgeInsets().left * 2 - CGFloat(columnCount() * itemSizeW)) / 2)
        }
    }
    
    func columnCount() -> Int {
        if (delegate?.responds(to: #selector(delegate?.columnCountInWaterFlowLayout(layout:))))!{
            return (delegate?.columnCountInWaterFlowLayout!(layout: self))!
        }else{

            return BDefaultColumnCount
        }
    }
    
    func edgeInsets() -> UIEdgeInsets {
        if (delegate?.responds(to: #selector(delegate?.itemEdgeInsetInWaterFlowLayout(layout:))))!{
            return (delegate?.itemEdgeInsetInWaterFlowLayout!(layout: self))!
        }else{

            return BDefaultEdgeInsets
        }
    }
    
}

extension CollectionLayout{

    
}
