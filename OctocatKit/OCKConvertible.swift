//
//  OCKConvertible.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/24.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import Foundation

public protocol OCKConvertible {
    
    associatedtype SourceType
    
    init?(source: SourceType)
    
}
