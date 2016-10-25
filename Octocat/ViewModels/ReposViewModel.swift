//
//  ReposViewModel.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/24.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit
import OctocatKit

class ReposViewModel: NSObject, UITableViewDataSource {

    @IBOutlet weak var view: ReposViewController!
    
    private(set) var queryBuilder: OCKRepositoryQueryBuilder!
    private(set) var resource: OCKLoadableResource<OCKRepositoryModel>!
    
    override init() {
        queryBuilder = OCKRepositoryQueryBuilder()
        resource = OCKLoadableResource(queryBuilder: queryBuilder)
        
        super.init()
    }
    
    func fetchData(reserving: Bool = false) {
        if resource.isLoading {
            resource.stopLoading()
        }
        
        resource.isReserving = reserving
        if !reserving {
            if resource.count == 0 {
                view.setLoadingIndicatorHidden(false)
            } else {
                view.refreshView.startAnimation()
            }
            
            queryBuilder.page = 1
        }
        view.segmentedControl.isEnabled = false
        view.segmentedControl.isUserInteractionEnabled = false
        
        if !resource.isLoading {
            resource.startLoading { [weak self] error in
                if error == .none {
                    self?.view.setLoadingIndicatorHidden(true)
                    self?.view.refreshView.stopAnimation()
                    self?.view.tableView.reloadData()
                    self?.view.segmentedControl.isEnabled = true
                    self?.view.segmentedControl.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func fetchNextPage() {
        queryBuilder.page += 1
        fetchData(reserving: true)
    }
    
    deinit {
        if resource.isLoading {
            resource.stopLoading()
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReposViewController.CellIdentifier, for: indexPath) as! RepoCell
        
        let repoModel = resource.get(at: indexPath.row)!
        
        cell.repoNameLabel.text = repoModel.name
        if repoModel.description?.isEmpty == false {
            cell.repoDescriptionLabel.text = repoModel.description
        } else {
            cell.repoDescriptionLabel.text = "(No description)"
        }
        cell.starCountLabel.text = "\(repoModel.forksCount ?? 0)"
        cell.langLabel.text = repoModel.language ?? "Other"
        cell.langImageView.image = badgeImage(forLanguage: repoModel.language)
        
        return cell
    }
    
}


extension ReposViewModel: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let keyword = searchController.searchBar.text, !keyword.isEmpty {
            resource.startFiltering(with: keyword)
        } else {
            resource.clearFilter()
        }
        view.tableView.reloadData()
    }
    
}
