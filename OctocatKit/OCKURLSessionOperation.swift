//
//  OCKURLSessionOperation.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/23.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit


public class OCKCacheHelper {
    
    public static let shared = OCKCacheHelper()
    
    private var etagMap = NSMutableDictionary()
    private var persistenceURL: URL! {
        let cachesDir = (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first)!
        return URL(string: "file://\(cachesDir)/ock_etags.plist")
    }
    
    fileprivate func putETag(_ etag: String, forURL url: URL) {
        etagMap.setObject(NSString(string: etag), forKey: NSString(string: url.absoluteString))
    }
    
    fileprivate func etag(forURL url: URL) -> String? {
        if let nsString = etagMap.object(forKey: NSString(string: url.absoluteString)) as? NSString {
            return String(nsString)
        }
        
        return nil
    }
    
    public func asyncToDisk() {
        if let data = try? PropertyListSerialization.data(fromPropertyList: etagMap, format: .binary, options: .allZeros) {
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
                etagMap = (try? PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil)) as? NSMutableDictionary ?? NSMutableDictionary()
            }
        }
    }
    
}


public class OCKURLSessionOperation: Operation {
    
    public var session: URLSession?
    public var etag: String? {
        return OCKCacheHelper.shared.etag(forURL: url)
    }
    public var needAuthorization = true
    
    private static var _observers = NSMutableArray()
    
    private let url: URL
    private var task: URLSessionTask?
    
    private var _data: Data?
    public var data: Data? {
        return _data
    }
    
    private var _semaphore = DispatchSemaphore(value: 0)
    
    init(url: URL) {
        self.url = url
        
        super.init()
    }
    
    public class func register(observer: OCKNetworkActivityObserver) {
        _observers.add(observer)
    }
    
    public class func unregister(observer: OCKNetworkActivityObserver) {
        _observers.remove(observer)
    }
    
    public override func main() {
        let session = self.session ?? URLSession.shared
        
        var urlString = url.absoluteString
        
        if needAuthorization {
            guard let accessToken = OCKSessionManager.default.accessToken else {
                return
            }
            
            if urlString.contains("?") {
                urlString += "&"
            } else {
                urlString += "?"
            }
            urlString += "access_token=\(accessToken)"
        }
        
        var request = URLRequest(url: URL(string: urlString)!)
        
        let cachedResponse = URLCache.shared.cachedResponse(for: request)
        
        if cachedResponse != nil {
            // If an error occurred, we can use the cached data.
            self._data = cachedResponse?.data
            
            if let etag = self.etag {
                request.addValue(etag, forHTTPHeaderField: "If-None-Match")
            }
        }
        
        self.task = session.dataTask(with: request) { (data, response, error) in
            defer {
                self._semaphore.signal()
            }
            
            guard data != nil && response != nil else {
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if statusCode == 304 {
                self._data = cachedResponse?.data
            } else if statusCode >= 200 && statusCode < 500 {
                self._data = data
                
                if let etag = httpResponse.allHeaderFields["Etag"] as? String {
                    OCKCacheHelper.shared.putETag(etag.substring(from: etag.index(etag.startIndex, offsetBy: 2)), forURL: self.url)
                    URLCache.shared.storeCachedResponse(CachedURLResponse(response: response!, data: data!), for: request)
                }
            }
        }
        
        self.task?.resume()
        notifyObservers()
        _semaphore.wait()
        notifyObservers()
    }
    
    public override func cancel() {
        if self.task?.state == .running {
            self.task?.cancel()
            _semaphore.signal()
        }
    }
    
    private func notifyObservers() {
        // What if the state changes while enumerating?
        guard let state = self.task?.state else {
            return
        }
        
        OCKURLSessionOperation._observers.enumerateObjects({ observer, _, _ in
            if state == .running {
                (observer as! OCKNetworkActivityObserver).networkActivityDidBegin?()
            } else {
                (observer as! OCKNetworkActivityObserver).networkActivityDidEnd?()
            }
        })
    }
    
}
