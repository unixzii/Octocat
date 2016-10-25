//
//  NetworkActivityIndicatorManager.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/24.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit
import OctocatKit

class NetworkActivityIndicatorManager: NSObject, OCKNetworkActivityObserver {

    static let `default` = NetworkActivityIndicatorManager()
    
    private var activeCount = 0
    
    func updateState() {
        let app = UIApplication.shared
        
        if activeCount > 0 {
            app.isNetworkActivityIndicatorVisible = true
        } else {
            activeCount = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                if self.activeCount == 0 {
                    app.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    func networkActivityDidBegin() {
        activeCount += 1
        updateState()
    }
    
    func networkActivityDidEnd() {
        activeCount -= 1
        updateState()
    }
    
}
