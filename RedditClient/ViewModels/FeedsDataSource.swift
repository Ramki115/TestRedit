//
//  FeedsDataSource.swift
//  RedditClient
//
//  Created by Ram Jalla on 09/10/20.
//

import Foundation
import UIKit

class FeedsDataSource: GenericDataSource<Feed>, UITableViewDataSource, UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        let feed = data.value[indexPath.row]
        cell.configure(with: feed)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == data.value.count - 1 {
            delegate?.shouldFetchMoreFeeds?()
        }
    }
    
    
}
