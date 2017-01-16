//
//  UIViewControllerExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

import UIKit

extension UIViewController {
    // MARK: - Notifications
    //TODO: Document this part
    public func addNotificationObserver(name: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }

    public func removeNotificationObserver(name: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
    }

    public func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }


    //EZSE: Makes the UIViewController register tap events and hides keyboard when clicked somewhere in the ViewController.
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    

    public func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - VC Container

    /// EZSwiftExtensions
    public var top: CGFloat {
        get {
            if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
                return visibleViewController.top
            }
            if let nav = self.navigationController {
                if nav.isNavigationBarHidden {
                    return view.top
                } else {
                    return nav.navigationBar.bottom
                }
            } else {
                return view.top
            }
        }
    }

    /// EZSwiftExtensions
    public var bottom: CGFloat {
        get {
            if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
                return visibleViewController.bottom
            }
            if let tab = tabBarController {
                if tab.tabBar.isHidden {
                    return view.bottom
                } else {
                    return tab.tabBar.top
                }
            } else {
                return view.bottom
            }
        }
    }

    /// EZSwiftExtensions
    public var tabBarHeight: CGFloat {
        get {
            if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
                return visibleViewController.tabBarHeight
            }
            if let tab = self.tabBarController {
                return tab.tabBar.frame.size.height
            }
            return 0
        }
    }

    /// EZSwiftExtensions
    public var navigationBarHeight: CGFloat {
        get {
            if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
                return visibleViewController.navigationBarHeight
            }
            if let nav = self.navigationController {
                return nav.navigationBar.h
            }
            return 0
        }
    }

    /// EZSwiftExtensions
    public var navigationBarColor: UIColor? {
        get {
            if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
                return visibleViewController.navigationBarColor
            }
            return navigationController?.navigationBar.tintColor
        } set(value) {
            navigationController?.navigationBar.barTintColor = value
        }
    }

    /// EZSwiftExtensions
    public var navBar: UINavigationBar? {
        get {
            return navigationController?.navigationBar
        }
    }

    /// EZSwiftExtensions
    public var applicationFrame: CGRect {
        get {
            return CGRect(x: view.x, y: top, width: view.w, height: bottom - top)
        }
    }

    // MARK: - VC Flow

    /// EZSwiftExtensions
    public func pushVC(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }

    /// EZSwiftExtensions
    public func popVC() {
        navigationController?.popViewController(animated: true)
    }

    /// EZSwiftExtensions
    public func presentVC(vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }

    /// EZSwiftExtensions
    public func dismissVC(completion: (() -> Void)? ) {
        dismiss(animated: true, completion: completion)
    }

    /// EZSwiftExtensions
    public func addAsChildViewController(vc: UIViewController, toView: UIView) {
        toView.addSubview(vc.view)
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
    }

    ///EZSE: Adds image named: as a UIImageView in the Background
    func setBackgroundImage(named: String) {
        let image = UIImage(named: named)
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
    }

    ///EZSE: Adds UIImage as a UIImageView in the Background
    @nonobjc func setBackgroundImage(image: UIImage) {
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
    }
    
    
    func customLizeNavigationBarBackBtn() -> Void {
        var backButton:UIButton!
        backButton = UIButton.init(type: UIButtonType.custom)
        backButton.frame = CGRect(x:0.0, y: 0.0, width: 50.0, height: 44.0)
        backButton.imageView?.contentMode = UIViewContentMode.center
        backButton.setImage(UIImage(named: "nav_back"), for: UIControlState.normal)
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        backButton.addTarget(self, action: #selector(backAction), for: UIControlEvents.touchUpInside)
        let backBarBtnItem:UIBarButtonItem = UIBarButtonItem.init(customView: backButton)
        backBarBtnItem.style = UIBarButtonItemStyle.plain
        setLeftBarButtonItem(barButtonItem: backBarBtnItem)
        
    }
    
    func setLeftBarButtonItem(barButtonItem:UIBarButtonItem) -> Void {
        let negativeSpace:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        
        self.navigationItem.leftBarButtonItems = [negativeSpace, barButtonItem]
        
    }
    
    func backAction() -> Void {
        popVC()
    }
    
    /**隐藏导航条下面的一条黑线*/
    func hiddenNavBottomLine() -> Void {
        let navBottomLine = getLineViewInNavigationBar(view: (navigationController?.navigationBar)!)
        navBottomLine?.isHidden = true
    }
    
    /**显示导航条下面的一条黑线*/
    func showNavBottomLine() -> Void {
        let navBottomLine = getLineViewInNavigationBar(view: (navigationController?.navigationBar)!)
        navBottomLine?.isHidden = false
    }
    
    /**找到导航栏下面的黑线*/
    func getLineViewInNavigationBar(view:UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        
        for subView in view.subviews {
            let imageView = getLineViewInNavigationBar(view: subView)
            if (imageView != nil) {
                return imageView
            }
            
        }
        
        return nil
    }
    
}
