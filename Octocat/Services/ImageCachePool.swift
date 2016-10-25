//
//  ImageCachePool.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/23.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit

class ImageCachePool {

    static let shared = ImageCachePool()
    
    var pool = NSCache<NSString, UIImage>()
    
    init() {
        pool.countLimit = 50
    }
    
    func putImage(_ image: UIImage, forKey key: String) {
        pool.setObject(image, forKey: NSString(string: key))
    }
    
    func image(forKey key: String) -> UIImage? {
        return pool.object(forKey: NSString(string: key))
    }
    
}
