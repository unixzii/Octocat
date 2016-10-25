//
//  RepoDetailsViewModel.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/24.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit
import OctocatKit

protocol RepoDetailsItemModel {
    
    var cellIdentifier: String { get }
    
    func configureCell(cell: UITableViewCell)
    
}


struct RepoTitleItemModel: RepoDetailsItemModel {
    
    var repoModel: OCKRepositoryModel
    
    var cellIdentifier: String {
        return "Title Cell"
    }
    
    func configureCell(cell: UITableViewCell) {
        let cell = cell as! RepoTitleCell
        cell.titleLabel.text = repoModel.fullName
        cell.descriptionLabel.text = repoModel.description
    }
    
}


struct RepoStaticsItemModel: RepoDetailsItemModel {
    
    var repoModel: OCKRepositoryModel
    
    var cellIdentifier: String {
        return "Statics Cell"
    }
    
    func configureCell(cell: UITableViewCell) {
        let nanPlaceholder = "--"
        
        let watch = cell.viewWithTag(1) as! StackedLabel
        watch.titleLabel.text = "Watch"
        if let watchersCount = repoModel.watchersCount {
            watch.numberLabel.text = "\(watchersCount)"
        } else {
            watch.numberLabel.text = nanPlaceholder
        }
        
        let star = cell.viewWithTag(2) as! StackedLabel
        star.titleLabel.text = "Star"
        if let stargazersCount = repoModel.stargazersCount {
            star.numberLabel.text = "\(stargazersCount)"
        } else {
            star.numberLabel.text = nanPlaceholder
        }
        
        let fork = cell.viewWithTag(3) as! StackedLabel
        fork.titleLabel.text = "Fork"
        if let forksCount = repoModel.forksCount {
            fork.numberLabel.text = "\(forksCount)"
        } else {
            fork.numberLabel.text = nanPlaceholder
        }
    }
    
}


struct RepoActionItemModel: RepoDetailsItemModel {
    
    var title: String
    var image: UIImage?
    var segueIdentifier: SegueIdentifier
    
    var cellIdentifier: String {
        return "Action Cell"
    }
    
    func configureCell(cell: UITableViewCell) {
        (cell.viewWithTag(1) as! UIImageView).image = image
        (cell.viewWithTag(2) as! UILabel).text = title
    }
    
}


class RepoDetailsViewModel: NSObject, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var view: RepoDetailsViewController!
    var repoModel: OCKRepositoryModel!
    
    private var itemModels = [(String, [RepoDetailsItemModel])]()
    
    func updateItemModels() {
        itemModels.removeAll()
        
        var section1 = [RepoDetailsItemModel]()
        section1.append(RepoTitleItemModel(repoModel: repoModel))
        section1.append(RepoStaticsItemModel(repoModel: repoModel))
        
        var section2 = [RepoDetailsItemModel]()
        section2.append(RepoActionItemModel(title: "View Code", image: UIImage(named: "CodeIcon"), segueIdentifier: .showCommits))
        
        var section3 = [RepoDetailsItemModel]()
        section3.append(RepoActionItemModel(title: "Commits", image: UIImage(named: "CommitIcon"), segueIdentifier: .showCommits))
        section3.append(RepoActionItemModel(title: "Branchs", image: UIImage(named: "BranchIcon"), segueIdentifier: .showCommits))
        section3.append(RepoActionItemModel(title: "Issues", image: UIImage(named: "IssueIcon"), segueIdentifier: .showCommits))
        section3.append(RepoActionItemModel(title: "Pull Requests", image: UIImage(named: "PRIcon"), segueIdentifier: .showCommits))
        section3.append(RepoActionItemModel(title: "Traffic", image: UIImage(named: "TrafficIcon"), segueIdentifier: .showCommits))
        
        itemModels.append(("", section1))
        itemModels.append(("", section2))
        itemModels.append(("", section3))
        
        view.tableView.reloadData()
        
        view.navigationItem.title = repoModel.name
    }
    
    // MARK: - Data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemModels[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemModel = itemModels[indexPath.section].1[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: itemModel.cellIdentifier, for: indexPath)
        itemModel.configureCell(cell: cell)
        return cell
    }
    
    // MARK: - Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemModel = itemModels[indexPath.section].1[indexPath.row]
        
        if itemModel is RepoActionItemModel {
            view.performSegue(withIdentifier: (itemModel as! RepoActionItemModel).segueIdentifier, sender: nil)
        }
    }
    
}
