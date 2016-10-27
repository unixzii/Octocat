//
//  SortPickerController.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/23.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit

class SortPickerController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var selectedIndex: Int = 0
    weak var target: AnyObject!
    var action: Selector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.selectedSegmentIndex = selectedIndex
        segmentedControl.addTarget(target, action: action, for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presentingViewController?.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.presentingViewController?.tabBarController?.tabBar.tintAdjustmentMode = .dimmed
        }, completion: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presentingViewController?.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.presentingViewController?.tabBarController?.tabBar.tintAdjustmentMode = .automatic
        }, completion: nil)
    }

}
