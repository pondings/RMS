//
//  DismissAnimator.swift
//  RMS-2
//
//  Created by Pondz on 1/23/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit

class PullDownDismiss: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        else {return}
        let container = transitionContext.containerView
        let fromSize = fromVC.view.frame.size
        container.insertSubview(toVC.view, belowSubview: fromVC.view)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.view.frame = CGRect.init(origin: CGPoint.init(x: 0, y: fromSize.height), size: fromSize)
            toVC.view.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}

class LeftEdgeDismiss: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else {return}
        let container = transitionContext.containerView
        container.insertSubview(toVC.view, belowSubview: fromVC.view)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            let point = CGPoint.init(x: UIScreen.main.bounds.width, y: 0)
            fromVC.view.frame = CGRect.init(origin: point, size: fromVC.view.frame.size)
            toVC.view.alpha = 1
        }, completion: {_ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}
