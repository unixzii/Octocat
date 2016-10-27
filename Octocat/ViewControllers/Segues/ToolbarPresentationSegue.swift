//
//  ToolbarPresentationSegue.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/23.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit

class ToolbarPresentationSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    override func perform() {
        destination.transitioningDelegate = self
        //destination.modalPresentationStyle = .custom
        
        super.perform()
    }
    
    /*
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ToolbarPresentationController(presentedViewController: presented, presenting: source)
    }
    */
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        
        let containerView = transitionContext.containerView
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
        if destination == toVC {
            // Present
            containerView.addSubview(toVC.view)
            toVC.view.frame = CGRect(x: 0, y: 64, width: containerView.frame.width, height: toVC.preferredContentSize.height)
            toVC.view.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -toVC.preferredContentSize.height)
            
            UIView.animate(withDuration: transitionDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
                toVC.view.transform = .identity
                fromVC.view.alpha = 0.85
            }, completion: {
                transitionContext.completeTransition($0)
            })
        } else {
            // Dismiss
            UIView.animate(withDuration: transitionDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
                fromVC.view.frame.origin.y -= fromVC.view.frame.height
                toVC.view.alpha = 1
            }, completion: {
                transitionContext.completeTransition($0)
            })
        }
    }
    
}


fileprivate class ToolbarPresentationController: UIPresentationController {
    
    let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    @objc fileprivate func dimViewDidTap() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    fileprivate override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        dimView.frame = containerView!.bounds
        dimView.frame.origin.y = 65
        dimView.frame.size.height -= 65
        dimView.alpha = 0
        dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimViewDidTap)))
        containerView?.addSubview(dimView)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimView.alpha = 1
        }, completion: nil)
    }
    
    fileprivate override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        if !completed {
            dimView.removeFromSuperview()
        }
    }
    
    fileprivate override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimView.alpha = 0
        }, completion: nil)
    }
    
    fileprivate override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        if completed {
            dimView.removeFromSuperview()
        }
    }
    
}
