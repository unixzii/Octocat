//
//  OCKCommitsQueryBuilder.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/24.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import Foundation

public class OCKCommitsQueryBuilder: OCKPagedQueryBuilder {
    
    public var fullname: String!
    public var page: Int = 1
    
    public init() {}
    
    public var queryURL: URL {
        let urlString: String = "https://api.github.com/repos/\(fullname!)/commits"
        
        return URL(string: urlString + "?page=\(page)")!
    }
    
    public var needAuthorization: Bool {
        return false
    }
    
}
