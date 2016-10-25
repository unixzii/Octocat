//
//  OCKNetworkActivityObserver.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/24.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import Foundation

@objc public protocol OCKNetworkActivityObserver {
    
    @objc optional func networkActivityDidBegin()
    
    @objc optional func networkActivityDidEnd()
    
}
