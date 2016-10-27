//
//  PagedContentViewModel.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/27.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit
import OctocatKit

@objc protocol PagedContentViewModel: NSObjectProtocol {

    func refreshData()
    
    func fetchData(reserving: Bool)
    
    func fetchNextPage()
    
}
