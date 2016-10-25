//
//  StackedLabel.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/24.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit

class StackedLabel: UIView {

    var numberLabel: UILabel!
    var titleLabel: UILabel!
    
    var isHighlighted: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.233) {
                self.backgroundColor = self.isHighlighted ? UIColor(white: 0, alpha: 0.1) : .white
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        numberLabel = UILabel()
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.font = UIFont.boldSystemFont(ofSize: 19)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = UIColor.lightGray
        
        addSubview(numberLabel)
        addSubview(titleLabel)
        
        addConstraint(numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8))
        addConstraint(numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor))
        addConstraint(titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6))
        addConstraint(titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        isHighlighted = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        isHighlighted = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        isHighlighted = false
    }

}
