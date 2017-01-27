//
//  DismissAnimator.swift
//  RMS-2
//
//  Created by Pondz on 1/23/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit
import Material

class PullToRight: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.view(forKey: .from),
            let toVC = transitionContext.view(forKey: .to)
        else {return}
        let container = transitionContext.containerView
        container.addSubview(toVC)
        let toFrame = toVC.frame
        toVC.frame.origin.x = -toFrame.size.width
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toVC.alpha = 1
            toVC.frame.origin.x = 0
            fromVC.frame.origin.x = fromVC.frame.size.width
            fromVC.alpha = 0.5
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}

class QRReaderDismiss: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else {return}
        let container = transitionContext.containerView
        let mainTabBar = toVC as? MainTabBarCtrl
        let qrBtn = mainTabBar?.qrBtn
        let height : CGFloat = 60
        let width : CGFloat = 60
        let xPosition : CGFloat = mainTabBar!.viewFrame.width - 68
        let yPosition : CGFloat = (mainTabBar!.viewFrame.height - 68) - mainTabBar!.bottomBarFrame.height
        container.insertSubview(toVC.view, belowSubview: fromVC.view)
        fromVC.view.alpha = 0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            qrBtn?.frame = CGRect.init(origin: CGPoint.init(x: xPosition, y: yPosition), size: CGSize.init(width: width, height: height))
            qrBtn?.backgroundColor = Color.lightBlue.base
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}

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
