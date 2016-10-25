//
//  OCKRepositoryModel.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/23.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import Foundation

public struct OCKRepositoryModel: OCKFilterable {
    
    public let name: String?
    public let fullName: String?
    public let isPrivate: Bool?
    public let isFork: Bool?
    public let htmlURL: String?
    public let description: String?
    public let stargazersCount: Int?
    public let watchersCount: Int?
    public let forksCount: Int?
    public let language: String?
    
    public func filter(with keyword: String) -> Bool {
        if name?.contains(keyword) == true || description?.contains(keyword) == true {
            return true
        }
        
        return false
    }
    
}


extension OCKRepositoryModel: OCKConvertible {
    
    public typealias SourceType = Any
    
    public init?(source: Any) {
        if let json = source as? [String:Any] {
            name = json["name"] as? String
            fullName = json["full_name"] as? String
            isPrivate = json["private"] as? Bool
            isFork = json["fork"] as? Bool
            htmlURL = json["html_url"] as? String
            description = json["description"] as? String
            stargazersCount = json["stargazers_count"] as? Int
            watchersCount = json["watchers_count"] as? Int
            forksCount = json["forks"] as? Int
            language = json["language"] as? String
            
            return
        }
        
        return nil
    }
    
}
