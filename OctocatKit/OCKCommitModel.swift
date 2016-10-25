//
//  OCKCommitModel.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/24.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import Foundation

public struct OCKCommitModel: OCKFilterable {
    
    public let sha: String?
    public let committerName: String?
    public let committerAvatarURL: URL?
    public let date: Date?
    public let message: String?
    
    public func filter(with keyword: String) -> Bool {
        if sha?.contains(keyword) == true || message?.contains(keyword) == true {
            return true
        }
        
        return false
    }
    
}


extension OCKCommitModel: OCKConvertible {
    
    public typealias SourceType = Any
    
    public init?(source: Any) {
        if let json = source as? [String:Any] {
            sha = json["sha"] as? String
            
            guard let commit = json["commit"] as? [String:Any] else {
                return nil
            }
            
            guard let committer = commit["committer"] as? [String:String] else {
                return nil
            }
            
            committerName = committer["name"]
            date = OCKCommitModel.parseDate(from: committer["date"])
            message = commit["message"] as? String
            
            var avatarURL: URL? = nil
            
            if let loginCommitter = json["committer"] as? [String:Any] {
                avatarURL = URL(string: loginCommitter["avatar_url"] as? String ?? "")
            }
            
            if avatarURL == nil {
                committerAvatarURL = URL(string: "https://camo.githubusercontent.com/c7561de651b867e74cb03e178c107104f3f54e19/68747470733a2f2f312e67726176617461722e636f6d2f6176617461722f39623732326639333932303931366636326266353132633532636363636137383f643d68747470732533412532462532466173736574732d63646e2e6769746875622e636f6d253246696d6167657325324667726176617461727325324667726176617461722d757365722d3432302e706e6726723d7826733d313430")!
            } else {
                committerAvatarURL = avatarURL
            }
            
            return
        }
        
        return nil
    }
    
    private static func parseDate(from string: String?) -> Date? {
        guard string != nil else {
            return nil
        }
        
        let formattedString = string!.replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: "")
        let format = DateFormatter()
        format.dateFormat = "YYYY-MM-dd hh:mm:ss"
        return format.date(from: formattedString)
    }
    
}
