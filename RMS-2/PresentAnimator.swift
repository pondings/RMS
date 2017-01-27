//
//  PresentAnimator.swift
//  RMS-2
//
//  Created by Pondz on 1/23/2560 BE.
//  Copyright © 2560 Pondz. All rights reserved.
//

import UIKit

class PushToLeft: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else {return}
        let container = transitionContext.containerView
        let fromFrame = fromVC.view.frame
        let toFrame = CGRect.init(origin: CGPoint.init(x: fromFrame.width, y: 0), size: toVC.view.frame.size)
        toVC.view.frame = toFrame
        toVC.view.alpha = 0.5
        container.addSubview(toVC.view)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toVC.view.frame.origin.x = 0
            toVC.view.alpha = 1
            fromVC.view.frame.origin.x = -fromVC.view.frame.width
            fromVC.view.alpha = 0.5
        }, completion: {_ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}

class QRReaderPresent: NSObject,UIViewControllerAnimatedTransitioning{
    
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
        let mainTabBar = fromVC as? MainTabBarCtrl
        let qrButton = mainTabBar?.qrBtn
        toVC.view.alpha = 0
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                qrButton?.frame = CGRect.init(origin: fromVC.view.frame.origin, size: fromVC.view.frame.size)
                qrButton?.backgroundColor = .black
                toVC.view.alpha = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3, animations: {
                qrButton?.imageView?.alpha = 0
            })
        }, completion: {_ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

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

class LeftPresent: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else {return}
        let container = transitionContext.containerView
        let toVCOrigin = CGPoint.init(x: UIScreen.main.bounds.width, y: 0)
        toVC.view.frame = CGRect.init(origin: toVCOrigin, size: toVC.view.frame.size)
        container.addSubview(toVC.view)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.view.alpha = 0.5
            toVC.view.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: toVC.view.frame.size)
        }, completion: {_ in transitionContext.completeTransition(!transitionContext.transitionWasCancelled)})
    }
    
}
