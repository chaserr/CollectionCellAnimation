//
//  MessageCollectionViewCell.swift
//  CollectionCellAnimationDemo
//
//  Created by 童星 on 2017/1/13.
//  Copyright © 2017年 童星. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var leftConstriant: NSLayoutConstraint!
    @IBOutlet weak var rightConstriant: NSLayoutConstraint!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImageConstriant: NSLayoutConstraint!
    @IBOutlet weak var rightImageConstriant: NSLayoutConstraint!
    var _leftImageItem:UIImage? = nil
    var _rightImageItem:UIImage? = nil
    var leftImageItem:UIImage?{
        set{
            self._leftImageItem = newValue
        }
        get{
            return self._leftImageItem
        }
    }
    var rightImageItem:UIImage?{
        set{
            self._rightImageItem = newValue
        }
        get{
            return self._rightImageItem
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        leftView.clipsToBounds = true
        rightView.clipsToBounds = true
        let Touch = UITapGestureRecognizer(target: self, action: #selector(MessageCollectionViewCell.clicked(recognizer:)))
        self.backgroundColor = UIColor.white
        self.addGestureRecognizer(Touch)
    }
    internal func addjustImageViewHeight() ->Void{
        if self.leftImageItem == nil {
            return
        }
        if self.rightImageItem == nil{
            return
        }
        let queue = OperationQueue()
        let operation = BlockOperation { 
            let collectionView:UICollectionView =  self.superview as! UICollectionView
            let currentOffset = collectionView.contentOffset
            //图片的缩放比例,然后根据imageview的宽度计算图片的等比例缩放高度最低为150
            var leftImageScale:CGFloat? = nil
            var rightImageScale:CGFloat? = nil
            if self.leftImage.image != nil {
                leftImageScale = (self.leftImage.image?.size.height)!/(self.leftImage.image?.size.width)!
            }else{
                leftImageScale = 1
            }
            if self.rightImage.image != nil{
                rightImageScale = (self.rightImage.image?.size.height)!/(self.rightImage.image?.size.width)!
            }else{
                rightImageScale = 1
            }
            var leftImageViewHeight = self.leftImage.frame.width*leftImageScale!
            
            var rightImageViewHeight = self.rightImage.frame.width*rightImageScale!
            if leftImageViewHeight<150 {
                leftImageViewHeight = 150
            }
            if rightImageViewHeight < 150 {
                rightImageViewHeight = 150
            }
            OperationQueue.main.addOperation({
                    self.leftImageConstriant.constant = leftImageViewHeight
                    self.rightImageConstriant.constant = rightImageViewHeight
                    //此方法主要用于传入当前offset然后计算cell的图片的constriant的值，以达到滑动的时候cell的image也有轻微偏移的动画效果
                    if self.frame.origin.y<=currentOffset.y {
                        self.leftConstriant.constant = 0
                        self.rightConstriant.constant = 0
                    }else if self.frame.origin.y>=(currentOffset.y+kScreenHeight){
                        self.leftConstriant.constant = -(leftImageViewHeight-120)
                        self.rightConstriant.constant = -(rightImageViewHeight-120)
                    }else{
                        let leftScale = (leftImageViewHeight-120)/(kScreenHeight)
                        let rightScale = (rightImageViewHeight-120)/(kScreenHeight)
                        self.leftConstriant.constant =  max(-(self.frame.origin.y-currentOffset.y)*leftScale, -(leftImageViewHeight-120))
                        self.rightConstriant.constant = max(-(self.frame.origin.y-currentOffset.y)*rightScale, -(rightImageViewHeight-120))
                    }
            
                        })
                }
            queue.addOperation(operation)
        }
    
    func clicked(recognizer: UITapGestureRecognizer) {
        let mySuperView = self.superview as! UICollectionView
        let offsetY = mySuperView.contentOffset.y
        let point =  recognizer.location(in: self.superview)
        let pointInScreen = CGPoint(x:point.x, y:point.y-offsetY)
        let ctl = self.viewCtl(responder: self)
        var image:UIImage?
        if point.x <= kScreenWidth/2{
            image = self.leftImageItem!
        }else{
            image = self.rightImageItem!
        }
        let imageCtl = ImageViewController(image:image! ,animationPoint: pointInScreen)
        ctl?.navigationController?.pushViewController(imageCtl, animated: false)
    }
    //通过响应者链找到ctl
    func viewCtl(responder:AnyObject?) -> UIViewController?{
        let nextResponder = responder?.next
        if nextResponder is UIViewController {
            let ctl = nextResponder as! UIViewController
            return ctl
        }else if (nextResponder is UIView){
            return self.viewCtl(responder: nextResponder!)
        }
        return nil
    }
}
