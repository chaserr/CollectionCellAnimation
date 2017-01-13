//
//  ImageViewController.swift
//  CollectionCellAnimationDemo
//
//  Created by 童星 on 2017/1/13.
//  Copyright © 2017年 童星. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, CAAnimationDelegate {
    var animationPoint:CGPoint?//用于动画开始的点
    var maskLayer:CAShapeLayer?
    var imageView:UIImageView? = nil
    var image:UIImage? = nil{
        willSet{
            let scale = (newValue?.size.height)!/(newValue?.size.width)!
            var imageHeight = kScreenWidth*scale
            if imageHeight>kScreenHeight {
                imageHeight = kScreenHeight
            }
            self.imageView?.frame = CGRect(x:0, y:0, width:kScreenWidth, height:imageHeight)
        }
        didSet{
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(image:UIImage,animationPoint:CGPoint) {
        self.image = image
        self.animationPoint = animationPoint
        
        self.imageView = UIImageView(frame: CGRect(x:0, y:0, width:kScreenWidth, height:kScreenHeight))
        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.imageView?.isUserInteractionEnabled = true
        self.imageView?.image = self.image
        super.init(nibName: nil, bundle: nil)
    }
    func configure(){
        self.maskLayer = CAShapeLayer()
        self.maskLayer?.fillColor = UIColor.clear.cgColor
        self.maskLayer?.strokeColor = UIColor.red.cgColor
        self.maskLayer?.lineWidth = 50
        self.maskLayer?.frame = CGRect(x:0, y:0, width:kScreenWidth, height:kScreenHeight)
        self.maskLayer?.path = UIBezierPath(ovalIn: CGRect(x:((animationPoint?.x)!)-50, y:(animationPoint?.y)!-50, width:50, height:50)).cgPath
        self.view.layer.mask = self.maskLayer
        
        //先将maskView的属性直接不做动画设置到目标值，这样当动画完成以后就不会返回为原来的样子，就不会闪一下
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        self.maskLayer?.path = UIBezierPath(ovalIn: CGRect(x:0, y:0, width:kScreenHeight, height:kScreenHeight)).cgPath
        self.maskLayer?.lineWidth = kScreenHeight
        CATransaction.commit()
        
        //添加动画
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = UIBezierPath(ovalIn: CGRect(x:(animationPoint?.x)!-50, y:(animationPoint?.y)!-50, width:50, height:50)).cgPath
        animation.toValue = UIBezierPath(ovalIn: CGRect(x:0, y:0, width:kScreenHeight, height:kScreenHeight)).cgPath
        animation.delegate = self
        let linWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        linWidthAnimation.fromValue = 50
        linWidthAnimation.toValue = kScreenHeight
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animation, linWidthAnimation]
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        groupAnimation.duration = 1
        groupAnimation.delegate = self
        
        self.maskLayer?.add(groupAnimation, forKey: "stroke")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.configure()
        
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(self.imageView!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.view.addSubview(imageView!)
        // Dispose of any resources that can be recreated.
    }
//    func backClicked(sender:UIButton){
//        self.navigationController?.popViewControllerAnimated(true)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //动画代理
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.maskLayer?.removeFromSuperlayer()
    }

}
