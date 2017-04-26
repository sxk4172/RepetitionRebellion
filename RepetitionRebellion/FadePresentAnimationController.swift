//
//  FadePresentAnimationController.swift
//  Repetition Rebellion
//
//  Created by Sean Maraia on 6/27/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit

// MARK: - Fade Transition

class FadeTransitionAnimation: TransitionManagerAnimation {
     func transition(
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        isDismissing: Bool,
        duration: TimeInterval,
        completion: @escaping () -> Void) {
        if isDismissing {
            closeAnimation(container: container,
                           fromViewController: fromViewController,
                           toViewController: toViewController,
                           duration: duration,
                           completion: completion)
        } else {
            openAnimation(container: container,
                          fromViewController: fromViewController,
                          toViewController: toViewController,
                          duration: duration,
                          completion: completion)
        }
    }
    
    func openAnimation (
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: TimeInterval,
        completion: @escaping () -> Void) {
        toViewController.view.alpha = 0
        container.addSubview(toViewController.view)
        UIView.animate(withDuration: duration/2,
                                   animations: {
                                    fromViewController.view.alpha = 0
            }, completion: {
                finished in
                UIView.animate(withDuration: duration/2, animations: {toViewController.view.alpha = 1}, completion: {_ in completion()})
        })
    }
    
    func closeAnimation (
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: TimeInterval,
        completion: @escaping () -> Void) {
        container.addSubview(toViewController.view)
        container.bringSubview(toFront: fromViewController.view)
        UIView.animate(withDuration: duration,
                                   animations: {
                                    fromViewController.view.alpha = 0
            }, completion: {
                finished in
                UIView.animate(withDuration : duration/2, animations: {toViewController.view.alpha = 1}, completion: {_ in completion()})
        })
    }
}
