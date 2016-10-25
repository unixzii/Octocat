//
//  OCKLoadableResource.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/24.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit

public enum OCKResponseError {
    case none
    case badCredentials
    case notFound
    case parsingFailed
    case unknown
}

public class OCKLoadableResource<T: OCKConvertible> where T.SourceType == Any {

    public typealias CompletionHandler = (OCKResponseError) -> Void
    
    private var currentOperations = [Operation]()
    private var resourceSet = [T]()
    private var filteredSet: [T]?
    private var queryBuilder: OCKQueryBuilder
    
    private let lock = DispatchSemaphore(value: 1)
    
    public var isLoading: Bool {
        return currentOperations.count > 0
    }
    
    public var isReserving: Bool = false
    
    public var count: Int {
        var result: Int = 0
        
        withCriticalZone {
            if filteredSet != nil {
                result = filteredSet!.count
            } else {
                result = resourceSet.count
            }
        }
        
        return result
    }
    
    public init(queryBuilder: OCKQueryBuilder) {
        self.queryBuilder = queryBuilder
    }
    
    public func startLoading(_ completionHandler: @escaping CompletionHandler) {
        let urlOperation = OCKURLSessionOperation(url: queryBuilder.queryURL)
        urlOperation.needAuthorization = queryBuilder.needAuthorization
        
        let parseOperation = BlockOperation {
            var error: OCKResponseError = .none
            
            defer {
                OCKOperationQueues.main.addOperation {
                    self.currentOperations.removeAll()
                    completionHandler(error)
                }
            }
            
            guard let data = urlOperation.data else {
                error = .unknown
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                error = .parsingFailed
                return
            }
            
            error = self.parseError(json: json)
            guard error == .none else {
                return
            }
            
            self.withCriticalZone {
                if !self.isReserving {
                    self.resourceSet.removeAll()
                }
                
                if let array = json as? NSArray {
                    self.resourceSet.append(contentsOf: array.flatMap { T.init(source: $0) })
                } else {
                    if let object = T.init(source: json) {
                        self.resourceSet.append(object)
                    }
                }
            }
        }
        
        parseOperation.addDependency(urlOperation)
        
        OCKOperationQueues.computing.addOperation(parseOperation)
        OCKOperationQueues.io.addOperation(urlOperation)
        
        currentOperations.append(parseOperation)
        currentOperations.append(urlOperation)
    }
    
    public func startFiltering(with keyword: String) {
        if currentOperations.count > 0 {
            return
        }
        
        filteredSet = resourceSet.filter {
            if let filterable = $0 as? OCKFilterable {
                return filterable.filter(with: keyword)
            }
            return false
        }
    }
    
    public func clearFilter() {
        filteredSet = nil
    }
    
    public func stopLoading() {
        for op in currentOperations {
            if !op.isFinished {
                op.cancel()
            }
        }
        
        currentOperations.removeAll()
    }
    
    public func get(at index: Int) -> T? {
        var result: T?
        
        withCriticalZone {
            if filteredSet != nil {
                result = filteredSet![index]
            } else {
                result = resourceSet[index]
            }
        }
        
        return result
    }
    
    private func parseError(json: Any) -> OCKResponseError {
        if let json = json as? [String:String] {
            if json.keys.contains("message") && json.keys.contains("documentation_url") {
                switch json["message"]! {
                case "Bad credentials":
                    return .badCredentials
                case "Not Found":
                    return .notFound
                default:
                    return .unknown
                }
            }
        }
        
        return .none
    }
    
    private func withCriticalZone(_ block: () -> ()) {
        lock.wait()
        defer {
            lock.signal()
        }
        
        block()
    }
    
}
