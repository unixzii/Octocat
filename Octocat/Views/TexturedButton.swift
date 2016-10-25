//
//  TexturedButton.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/23.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit

class TexturedButton: UIButton {

    @IBInspectable var normalImage: UIImage? {
        didSet {
            updateImages()
        }
    }
    
    @IBInspectable var highlightedImage: UIImage? {
        didSet {
            updateImages()
        }
    }
    
    @IBInspectable var cornerCap: CGFloat = 0 {
        didSet {
            updateImages()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        updateImages()
    }
    
    func updateImages() {
        let capInsets: UIEdgeInsets = .init(top: cornerCap, left: cornerCap, bottom: cornerCap, right: cornerCap)
        setBackgroundImage(normalImage?.resizableImage(withCapInsets: capInsets), for: [])
        setBackgroundImage(highlightedImage?.resizableImage(withCapInsets: capInsets), for: .highlighted)
    }
    
}
