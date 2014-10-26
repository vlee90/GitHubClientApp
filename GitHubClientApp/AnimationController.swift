//
//  AnimationController.swift
//  GitHubClientApp
//
//  Created by Vincent Lee on 10/23/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UserViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserDetailViewController
        let containerView = transitionContext.containerView()
        toVC.view.alpha = 0.0
        containerView.addSubview(toVC.view)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            toVC.view.alpha = 1.0
            fromVC.view.alpha = 1.0
        }) { (sucess) -> Void in
            transitionContext.completeTransition(true)
        }
    }
}