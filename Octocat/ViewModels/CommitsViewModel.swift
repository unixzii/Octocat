//
//  CommitsViewModel.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/24.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit
import OctocatKit
import WebImage

class CommitsViewModel: NSObject, PagedContentViewModel, UITableViewDataSource {

    @IBOutlet weak var view: CommitsViewController!
    
    private(set) var queryBuilder: OCKCommitsQueryBuilder!
    private(set) var resource: OCKLoadableResource<OCKCommitModel>!
    
    override init() {
        queryBuilder = OCKCommitsQueryBuilder()
        resource = OCKLoadableResource(queryBuilder: queryBuilder)
        
        super.init()
    }
    
    func refreshData() {
        fetchData(reserving: false)
    }
    
    func fetchData(reserving: Bool) {
        if resource.isLoading {
            resource.stopLoading()
        }
        
        resource.isReserving = reserving
        if !reserving {
            view.refreshView.startAnimation()
            
            queryBuilder.page = 1
        }
        
        if !resource.isLoading {
            resource.startLoading { [weak self] error in
                if error == .none {
                    self?.view.refreshView.stopAnimation()
                    self?.view.tableView.reloadData()
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
    
    func beautifiedDateString(from date: Date?) -> String {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"]
        let calendar = Calendar.current
        let timeZone = TimeZone.current
        
        if date == nil {
            return "someday"
        }
        
        let components = calendar.dateComponents(in: timeZone, from: date!)
        
        return "\(months[components.month!]). \(components.day!)"
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommitsViewController.CellIdentifier, for: indexPath) as! CommitCell
        
        let commitModel = resource.get(at: indexPath.row)!
        
        cell.messageLabel.text = commitModel.message
        cell.infoLabel.text = "\(commitModel.committerName ?? "Someone") committed on \(beautifiedDateString(from: commitModel.date))"
        if let sha = commitModel.sha {
            cell.shaLabel.text = sha.substring(to: sha.index(sha.startIndex, offsetBy: 7))
        } else {
            cell.shaLabel.text = nil
        }
        cell.avatarImageView.sd_setImage(with: commitModel.committerAvatarURL, placeholderImage: UIImage(named: "ImagePlaceholder"), options: .handleCookies)
        
        return cell
    }
    
}
