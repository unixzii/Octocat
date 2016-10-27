//
//  PagedContentViewController.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/27.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit

class PagedContentViewController: UIViewController {

    @IBOutlet weak var refreshView: TableRefreshView!
    
    @IBOutlet var viewModel: PagedContentViewModel!

}


extension PagedContentViewController: UITableViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        refreshView.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndScroll(scrollView)
        }
    }
    
    func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        if abs(scrollView.contentOffset.y + scrollView.bounds.height - scrollView.contentSize.height) < 44 {
            viewModel.fetchNextPage()
        }
    }
    
}
