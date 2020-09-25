//
//  UIViewController+Extensions.swift
//  ChatWithFirebase
//
//  Created by SonHoang on 7/22/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit
extension NSObject {
    @nonobjc class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    var className: String {
        return type(of: self).className
    }
}

extension UIViewController {
    var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    var safeAreaInsetBottom: CGFloat {
        var height: CGFloat = 0
        if #available(iOS 11.0, *), let window = UIApplication.shared.keyWindow {
            height = window.safeAreaInsets.bottom
        }
        return height
    }
    
    public class func vc() -> Self {
        return self.init(nibName: String(describing: self), bundle: nil)
    }
    
    class func instantiate<T: UIViewController>(_: T.Type, storyboard: String) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        guard let ViewController = storyboard.instantiateViewController(withIdentifier: T.className) as? T else {
            fatalError("Can not instantiate viewcontroller from storyboard \(storyboard)")
        }
        return ViewController
    }
    
    static func instantiateFromStoryboard(identifier: String = "") -> Self {
        return instantiateFromStoryboard(viewControllerClass: self, identifier: identifier)
    }
    
    private static func instantiateFromStoryboard<T: UIViewController>(viewControllerClass: T.Type, identifier: String = #function, line: Int = #line, file: String = #file) -> T {
        var storyboardName = ""
        var controllerIdentifer = ""
        if identifier != "" {
            storyboardName = identifier
            controllerIdentifer = (viewControllerClass as UIViewController.Type).className
        } else {
            storyboardName = (viewControllerClass as UIViewController.Type).className
            controllerIdentifer = storyboardName
        }
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        guard let scene = storyboard.instantiateViewController(withIdentifier: controllerIdentifer) as? T else {
            fatalError("ViewController with identifier \(storyboardName), not found in \(storyboardName) Storyboard.\nFile : \(file) \nLine Number : \(line)")
        }
        return scene
    }
}
