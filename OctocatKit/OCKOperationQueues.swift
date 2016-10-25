//
//  OCKOperationQueues.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/23.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import Foundation

struct OCKOperationQueues {
    
    static let main = OperationQueue.main
    
    static let computing: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        queue.qualityOfService = .utility
        queue.name = "queue.cyandev.octocatkit.computing"
        
        return queue
    }()
    
    static let io: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 8
        queue.qualityOfService = .utility
        queue.name = "queue.cyandev.octocatkit.io"
        
        return queue
    }()
    
}
