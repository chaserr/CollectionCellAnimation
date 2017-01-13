//
//  DynamicCell.swift
//  DynamicCollectionCellExample
//
//  Created by 童星 on 2016/11/3.
//  Copyright © 2016年 童星. All rights reserved.
//

import UIKit

class DynamicCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var borderBtn: UIButton!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var address: UIButton!
    
    fileprivate var viewController: UIViewController?
    fileprivate var indexPath: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateContent(contentDict: [AnyHashable: Any], withVC viewController: UIViewController, withIndexPath indexPath: IndexPath) {
        
        self.viewController = viewController
        if indexPath.item == 1 {
            address.isEnabled = true
            nickName.text = "我"
            
        }else{
        
            address.isHidden = false
            nickName.text = "chaser"
            
        }
        
        imageView.setImage(size: imageView.frame.size, image: UIImage(named: "portrial")!)
        
    }

}

extension UIView{

    func setImage(size: CGSize, image: UIImage) {
        let bgImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        bgImageView.layer.cornerRadius = size.width / 2
        bgImageView.layer.masksToBounds = true
        bgImageView.contentMode = UIViewContentMode.scaleAspectFill
        bgImageView.image = UIImage.init(named: "portrial")
        addSubview(bgImageView)
        
    }
}
