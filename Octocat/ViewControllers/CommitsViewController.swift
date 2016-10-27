//
//  CommitsViewController.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/24.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit

class CommitsViewController: PagedContentViewController {
    
    static let CellIdentifier = "Cell"
    
    @IBOutlet weak var tableView: UITableView!
    
    var commitsViewModel: CommitsViewModel {
        return viewModel as! CommitsViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        tableView.contentInset = .init(top: 64, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        refreshView.action = #selector(CommitsViewModel.refreshData)
        
        viewModel.fetchData(reserving: false)
    }

}
