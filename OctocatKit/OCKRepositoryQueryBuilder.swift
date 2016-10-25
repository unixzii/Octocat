//
//  OCKRepositoryQueryBuilder.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/23.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import Foundation

public enum RepositoryType {
    case user
    case starred
}

public struct RepositorySortType: RawRepresentable {
    
    public typealias RawValue = String
    
    public var rawValue: String
    public let index: Int
    
    public init(rawValue: String, index: Int) {
        self.rawValue = rawValue
        self.index = index
    }
    
    public init(rawValue: String) {
        self.rawValue = rawValue
        self.index = -1
    }
    
    public static let created = RepositorySortType(rawValue: "created", index: 0)
    public static let updated = RepositorySortType(rawValue: "updated", index: 1)
    public static let pushed = RepositorySortType(rawValue: "pushed", index: 2)
    public static let fullName = RepositorySortType(rawValue: "full_name", index: 3)
    
}


public class OCKRepositoryQueryBuilder: OCKQueryBuilder {
    
    public var type: RepositoryType = .user
    public var sort: RepositorySortType = .created
    public var page = 1
    
    public init() {}
    
    public var queryURL: URL {
        let urlString: String = {
            switch type {
            case .user:
                return "https://api.github.com/user/repos"
            case .starred:
                return "https://api.github.com/user/starred"
            }
        }()
        
        return URL(string: urlString + "?sort=\(sort.rawValue)&page=\(page)")!
    }
    
    public var needAuthorization: Bool {
        return true
    }
    
}
