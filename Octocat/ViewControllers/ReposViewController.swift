//
//  ReposViewController.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/23.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit
import OctocatKit

class ReposViewController: UIViewController {

    static let CellIdentifier = "Cell"
    
    @IBOutlet var loadingIndicatorView: UIView!
    @IBOutlet weak var refreshView: TableRefreshView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet var viewModel: ReposViewModel!
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLoadingIndicatorHidden(false)
        
        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = .init(top: 64, left: 0, bottom: 0, right: 0)
        
        refreshView.action = #selector(ReposViewModel.fetchData)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = viewModel
        searchController.searchBar.autocapitalizationType = .none
        tableView.tableHeaderView = searchController.searchBar
        
        if OCKSessionManager.default.accessToken != nil {
            viewModel.fetchData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }

    @IBAction func sortButtonDidTap(_ sender: AnyObject) {
        if presentedViewController == nil {
            // Picker controller should not be presented yet.
            performSegue(withIdentifier: .sortPicker, sender: sender)
            (sender as! UIButton).isSelected = true
        } else {
            presentedViewController?.dismiss(animated: true, completion: nil)
            (sender as! UIButton).isSelected = false
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: AnyObject) {        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel.queryBuilder.type = .user
            break
        case 1:
            viewModel.queryBuilder.type = .starred
            break
        default:
            break
        }
        
        viewModel.fetchData()
    }
    
    func sortPickerSegmentedControlChanged(_ sender: AnyObject) {
        switch (sender as! UISegmentedControl).selectedSegmentIndex {
        case 0:
            viewModel.queryBuilder.sort = .created
            break
        case 1:
            viewModel.queryBuilder.sort = .updated
            break
        case 2:
            viewModel.queryBuilder.sort = .pushed
            break
        case 3:
            viewModel.queryBuilder.sort = .fullName
            break
        default:
            break
        }
        
        viewModel.fetchData()
    }
    
    func setLoadingIndicatorHidden(_ hidden: Bool) {
        if hidden {
            loadingIndicatorView.removeFromSuperview()
            tableView.isHidden = false
            return
        }
        
        guard case .none = loadingIndicatorView.superview else {
            return
        }
        
        view.addSubview(loadingIndicatorView)
        view.addConstraint(loadingIndicatorView.topAnchor.constraint(equalTo: view.topAnchor))
        view.addConstraint(loadingIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        view.addConstraint(loadingIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        view.addConstraint(loadingIndicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        
        tableView.isHidden = true
    }
    
    @IBAction func unwindInRepos(_ segue: UIStoryboardSegue) {
        if segue.source is LoginViewController {
            viewModel.fetchData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.sortPicker.rawValue {
            let destination = segue.destination as! SortPickerController
            destination.selectedIndex = viewModel.queryBuilder.sort.index
            destination.target = self
            destination.action = #selector(sortPickerSegmentedControlChanged(_:))
        }
        
        if segue.identifier == SegueIdentifier.repoDetails.rawValue {
            let destination = segue.destination as! RepoDetailsViewController
            destination.viewModel.repoModel = viewModel.resource.get(at: tableView.indexPathForSelectedRow!.row)
        }
    }

}


extension ReposViewController: UITableViewDelegate {
    
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
