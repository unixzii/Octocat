//
//  LoginViewController.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/23.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit
import OctocatKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: TexturedButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var notificationObservers = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationObservers.append(NotificationCenter.default.addObserver(forName: Notification.Name.loginPending, object: nil, queue: .main) { _ in
            self.loginButton.isHidden = true
            self.indicatorView.startAnimating()
        })
        
        notificationObservers.append(NotificationCenter.default.addObserver(forName: Notification.Name.loginFinished, object: nil, queue: .main) { _ in
            self.performSegue(withIdentifier: .unwindToRepos, sender: nil)
        })
        
        notificationObservers.append(NotificationCenter.default.addObserver(forName: Notification.Name.loginFailed, object: nil, queue: .main) { _ in
            self.loginButton.isHidden = false
            self.indicatorView.stopAnimating()
        })
    }
    
    deinit {
        notificationObservers.forEach {
            NotificationCenter.default.removeObserver($0)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func login(_ sender: AnyObject) {
        UIApplication.shared.open(OCKSessionManager.default.oauthURL, options: [:], completionHandler: nil)
    }
    
}
