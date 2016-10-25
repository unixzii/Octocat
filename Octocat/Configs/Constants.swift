//
//  Constants.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/23.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit


struct SegueIdentifier: RawRepresentable {
    
    typealias RawValue = String
    
    var rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    static let login = SegueIdentifier(rawValue: "Present Login View Controller")
    static let sortPicker = SegueIdentifier(rawValue: "Present Sort Picker")
    static let unwindToRepos = SegueIdentifier(rawValue: "Unwind To Repos")
    static let repoDetails = SegueIdentifier(rawValue: "Show Repo Details")
    static let showCommits = SegueIdentifier(rawValue: "Show Commits")
    
}


extension UIViewController {
    
    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
}


let languageColors = [
    "C": UIColor(red:0.33, green:0.33, blue:0.33, alpha:1.00),
    "Go": UIColor(red:0.22, green:0.38, blue:0.66, alpha:1.00),
    "C++": UIColor(red:0.95, green:0.31, blue:0.49, alpha:1.00),
    "Python": UIColor(red:0.22, green:0.45, blue:0.64, alpha:1.00),
    "HTML": UIColor(red:0.89, green:0.30, blue:0.18, alpha:1.00),
    "Shell": UIColor(red:0.55, green:0.87, blue:0.35, alpha:1.00),
    "Java": UIColor(red:0.69, green:0.44, blue:0.15, alpha:1.00),
    "JavaScript": UIColor(red:0.94, green:0.87, blue:0.40, alpha:1.00),
    "CSS": UIColor(red:0.34, green:0.25, blue:0.48, alpha:1.00),
    "Objective-C": UIColor(red:0.28, green:0.57, blue:0.99, alpha:1.00),
    "Swift": UIColor(red:0.99, green:0.67, blue:0.31, alpha:1.00),
    "Ruby": UIColor(red:0.44, green:0.09, blue:0.10, alpha:1.00),
    "Other": UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.00)
]

func badgeImage(forLanguage lang: String?) -> UIImage {
    let cacheKey = "badge_\(lang ?? "Other")"
    if let cache = ImageCachePool.shared.image(forKey: cacheKey) {
        return cache
    }
    
    var color = (languageColors[lang ?? "Other"] ?? languageColors["Other"])!
    let size: CGSize = .init(width: 10, height: 10)
    
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
    defer {
        UIGraphicsEndImageContext()
    }
    
    let context = UIGraphicsGetCurrentContext()!
    context.setFillColor(color.cgColor)
    context.fillEllipse(in: .init(origin: .zero, size: size))
    
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    ImageCachePool.shared.putImage(image, forKey: cacheKey)
    return image
}
