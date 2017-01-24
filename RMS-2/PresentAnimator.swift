//
//  PresentAnimator.swift
//  RMS-2
//
//  Created by Pondz on 1/23/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit

class BottomPresent: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        else {return}
        let container = transitionContext.containerView
        let toSize = toVC.view.frame.size
        toVC.view.frame = CGRect.init(origin: CGPoint.init(x: 0, y: toSize.height), size: toSize)
        container.addSubview(toVC.view)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            fromVC.view.alpha = 0.5
            toVC.view.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: toSize)
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}

class NavBarPresent: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        else {return}
        let container = transitionContext.containerView
        let toFrame = toVC.view.frame
        toVC.view.frame = CGRect.init(origin: CGPoint.init(x: -toFrame.width, y: toFrame.origin.y), size: toFrame.size)
        container.addSubview(toVC.view)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.view.alpha = 0.5
            toVC.view.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: toFrame.size)
        }, completion: {_ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}
