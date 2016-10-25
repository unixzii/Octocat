//
//  OCKSessionManager.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/23.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import Foundation

public class OCKSessionManager {

    public static let `default` = OCKSessionManager()
    
    public var containerURL: URL!
    public var registeredCallbackURL: String!
    
    public var clientID: String!
    public var clientSecret: String!
    
    public var oauthURL: URL {
        precondition(clientID != nil, "You didn't set the client id yet.")
        
        return URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientID!)")!
    }
    
    private var _accessToken: String?
    public var accessToken: String? {
        return _accessToken
    }
    
    private var persistenceURL: URL! {
        return URL(string: "\(containerURL.absoluteURL)/ock_session.plist")
    }
    
    public func login(withCode code: String, _ completionHandler: ((Bool) -> Void)?) {
        let url = URL(string: "https://github.com/login/oauth/access_token?client_id=\(clientID!)&client_secret=\(clientSecret!)&code=\(code)")!
        let urlOperation = OCKURLSessionOperation(url: url)
        urlOperation.needAuthorization = false
        
        let parseOperation = BlockOperation { 
            if let data = urlOperation.data {
                let str = String(data: data, encoding: .utf8)
                if let token = str?.components(separatedBy: "&").first?.components(separatedBy: "=")[1] {
                    self._accessToken = token
                    OCKOperationQueues.main.addOperation {
                        self.asyncToDisk()
                        completionHandler?(true)
                    }
                    return
                }
            }
            
            OCKOperationQueues.main.addOperation {
                completionHandler?(false)
            }
        }
        parseOperation.addDependency(urlOperation)
        
        OCKOperationQueues.computing.addOperation(parseOperation)
        OCKOperationQueues.io.addOperation(urlOperation)
    }
    
    public func logout() {
        _accessToken = nil
        asyncToDisk()
    }
    
    // TODO: Need refactor, but not now.
    public func asyncToDisk() {
        let plist = NSMutableDictionary()
        if _accessToken != nil {
            plist.setObject(NSString(string: _accessToken!), forKey: NSString(string: "AccessToken"))
        }
        
        if let data = try? PropertyListSerialization.data(fromPropertyList: plist, format: .binary, options: .allZeros) {
            do {
                try data.write(to: persistenceURL)
            } catch {
                debugPrint("Failed to async, error: \(error.localizedDescription)")
            }
        }
    }
    
    public func asyncFromDisk() {
        let url = persistenceURL!
        if FileManager.default.fileExists(atPath: url.path) {
            if let data = try? Data(contentsOf: url) {
                if let plist = (try? PropertyListSerialization.propertyList(from: data, options: [], format: nil)) as? NSMutableDictionary {
                    if let accessTokenNSString = plist.object(forKey: "AccessToken") as? NSString {
                        _accessToken = String(accessTokenNSString)
                    } else {
                        _accessToken = nil
                    }
                }
            }
        }
    }
    
}
