//
//  TableRefreshView.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/23.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit

let π: CGFloat = 3.1415926536


class TableRefreshView: UIView, UIScrollViewDelegate {
    
    enum State {
        case idle
        case pulling
        case ready
        case loading
    }
    
    var stateImageView1: UIImageView!
    var stateImageView2: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var target: AnyObject?
    var action: Selector?
    
    var isScrollViewDragging = false
    var state: State = .idle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonSetup()
    }
    
    func commonSetup() {
        self.isUserInteractionEnabled = false
        
        stateImageView1 = UIImageView(image: #imageLiteral(resourceName: "RefreshState1"))
        stateImageView2 = UIImageView(image: #imageLiteral(resourceName: "RefreshState2"))
        
        addSubview(stateImageView1)
        addSubview(stateImageView2)
    }
    
    func startAnimation() {
        if state == .loading {
            return
        }
        
        UIView.animate(withDuration: 0.3) { 
            self.scrollView?.contentOffset = CGPoint(x: 0, y: -150)
        }
        beginLoading(userInitiated: false)
    }
    
    func stopAnimation() {
        if state == .loading {
            endLoading()
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        resetState()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if state == .idle {
            stateImageView1.frame = bounds
            stateImageView2.frame = bounds
        }
    }
    
    // MARK: - State Managing
    
    private func resetState() {
        stateImageView1.isHidden = false
        stateImageView1.alpha = 1
        stateImageView1.transform = .identity
        stateImageView2.isHidden = true
        stateImageView2.alpha = 1
        stateImageView2.transform = .identity
        
        state = .idle
        
        setNeedsLayout()
    }
    
    private func beginPull() {
        if state == .idle {
            stateImageView1.isHidden = false
        } else if state != .pulling {
            UIView.animate(withDuration: 0.3) {
                self.stateImageView1.transform = .identity
            }
        }
        
        state = .pulling
    }
    
    private func thresholdReached() {
        UIView.animate(withDuration: 0.3) { 
            self.stateImageView1.transform = CGAffineTransform.identity.rotated(by: π)
        }
        
        state = .ready
    }
    
    private func beginLoading(userInitiated: Bool) {
        self.scrollView?.contentInset.top = 144
        
        self.stateImageView1.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.2, animations: { 
            self.stateImageView1.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            self.stateImageView1.alpha = 0
        }) { _ in
            self.stateImageView2.alpha = 0
            self.stateImageView2.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
            self.stateImageView2.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 9.0, options: [], animations: {
                self.stateImageView2.transform = .identity
                self.stateImageView2.alpha = 1
                }, completion: nil)
        }
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.values = [0, 10, 6, 4, 0].map { NSNumber(value: $0) }
        animation.duration = 1
        animation.repeatCount = HUGE
        stateImageView2.layer.removeAllAnimations()
        stateImageView2.layer.add(animation, forKey: "animation")
        
        state = .loading
        
        if target != nil && action != nil && userInitiated {
            let _ = (self.target as? NSObject)?.perform(self.action)
        }
    }
    
    private func endLoading() {
        self.stateImageView2.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.3, animations: { 
            self.stateImageView2.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            self.stateImageView2.alpha = 0
            if self.scrollView != nil {
                self.scrollView!.contentInset.top = 64
            }
        }) { _ in
            self.resetState()
        }
    }
    
    // MARK: - Delegate Forwarding
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrollViewDragging = true
        
        if state != .loading {
            resetState()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        transform = CGAffineTransform.identity.translatedBy(x: 0, y: -scrollView.contentOffset.y - 150)
        
        if isScrollViewDragging && state != .loading {
            if scrollView.contentOffset.y < -120 {
                thresholdReached()
            } else {
                beginPull()
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isScrollViewDragging = false
        
        if state != .loading {
            if state == .ready {
                beginLoading(userInitiated: true)
            } else {
                resetState()
            }
        }
    }

}
