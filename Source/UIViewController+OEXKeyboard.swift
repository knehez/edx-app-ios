//
//  UIViewController+OEXKeyboard.swift
//  edX
//
//  Created by Tang, Jeff on 6/22/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

import Foundation

extension UIViewController {
    // It's recommended to use ContentInsetsController instead of this. It works better with toolbars/navigation bars, etc.
    func handleKeyboard(scrollView: UIScrollView, _ backgroundView: UIView) {
        NSNotificationCenter.defaultCenter().oex_addObserver(self, name: UIKeyboardWillChangeFrameNotification) { (notification : NSNotification, vc, _) -> Void in
            if let info = notification.userInfo {
                let keyboardEndRectObject = info[UIKeyboardFrameEndUserInfoKey] as! NSValue
                var keyboardEndRect = keyboardEndRectObject.CGRectValue()
                keyboardEndRect = vc.view.convertRect(keyboardEndRect, fromView: nil)
                let intersectionOfKeyboardRectAndWindowRect = CGRectIntersection(vc.view.frame, keyboardEndRect)
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: intersectionOfKeyboardRectAndWindowRect.size.height, right: 0)
                if scrollView.contentOffset.y == 0 {
                    scrollView.contentOffset = CGPointMake(0, backgroundView.frame.origin.y)
                }
                else {
                    scrollView.contentOffset = CGPointZero
                }
            }
        }
    }
}