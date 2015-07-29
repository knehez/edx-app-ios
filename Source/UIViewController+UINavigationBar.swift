//
//  UIViewController+UINavigationBar.swift
//  edX
//
//  Created by Ehmad Zubair Chughtai on 29/07/2015.
//  Copyright (c) 2015 edX. All rights reserved.
//

import UIKit

extension UIViewController {
   
    public func setNavigationBar(isRootViewController : Bool, action : Selector?) {
        if isRootViewController {
            let navigationItem = UIBarButtonItem(image: UIImage(named: "ic_navigation"), style: .Plain, target: self, action: nil)
            if let navigationItemAction = action {
                navigationItem.action = navigationItemAction
            }
            
            self.navigationItem.leftBarButtonItem = navigationItem;
        }
    }
    
}
