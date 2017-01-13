//
//  SectionView.swift
//  CollectionCellAnimationDemo
//
//  Created by 童星 on 2017/1/13.
//  Copyright © 2017年 童星. All rights reserved.
//

import UIKit

class SectionView: UICollectionReusableView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var maskImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topCons: NSLayoutConstraint!
    var isHeader = true//判断是否为第一个section
    var imageItem:UIImage? = nil{
        willSet{
        }
        
        didSet{
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.translatesAutoresizingMaskIntoConstraints = true
        // Initialization code
    }
    override func layoutSubviews() {
        if isHeader {
            maskImageView.alpha = max(0,1-(self.frame.size.height-64)*alphaHeaderScale)
        }else{
            maskImageView.alpha = max(0, 1-(self.frame.size.height-64)*alphaSectionScale)
        }
        self.adjustTitleCenter()
    }
    internal func addjustImageViewHeight() ->Void{
        if self.imageItem == nil {
            return
        }
        let queue = OperationQueue()
        let operation = BlockOperation {
            let collectionView:UICollectionView =  self.superview as! UICollectionView
            let currentOffset = collectionView.contentOffset
            //图片的缩放比例然后根据imageview的宽度计算图片的等比例缩放高度最低为150
            var imageScale:CGFloat? = nil
            if self.imageItem != nil {
                imageScale = (self.imageItem!.size.height)/(self.imageItem!.size.width)
            }else{
                imageScale = 1
            }
            var imageHeight = self.imageView.frame.width*imageScale!
        
            if imageHeight<250 {
                imageHeight = 250
            }
            OperationQueue.main.addOperation({
                
                //此方法主要用于传入当前offset然后计算cell的图片的constriant的值，以达到滑动的时候cell的image也有轻微偏移的动画效果
                if self.frame.origin.y<=currentOffset.y {
                    self.topCons.constant = 0
                }else if self.frame.origin.y>=(currentOffset.y+kScreenHeight){
                    self.topCons.constant = -(imageHeight-220)
                }else{
                    let scale = (imageHeight-220)/(kScreenHeight)
                    self.topCons.constant =  max(-(self.frame.origin.y-currentOffset.y)*scale, -(imageHeight-220))
                }
                
            })
        }
        queue.addOperation(operation)
    }
    func adjustTitleCenter(){
        if self.frame.size.height == 64 {
            UIView.animate(withDuration: 0.25, animations: {
                self.titleLabel.center = CGPoint(x:kScreenWidth/2, y:44/2+20)
            })
        }else{
            self.titleLabel.frame.origin.y = self.frame.height-10-self.titleLabel.frame.size.height
            if self.titleLabel.frame.origin.x != 10 {
                UIView.animate(withDuration: 0.25, animations: {
                    self.titleLabel.frame.origin.x = 10
                })
            }
        }
    }
}
