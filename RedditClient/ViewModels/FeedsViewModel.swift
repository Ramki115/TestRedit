//
//  FeedsViewModel.swift
//  RedditClient
//
//  Created by Ram Jalla on 09/10/20.
//

import Foundation
import UIKit

class FeedsViewModel: NSObject {
    
    weak var service: FeedService?
    weak var dataSource: GenericDataSource<Feed>?
    var onErrorHandling : ((ErrorResult?) -> Void)?
    private var isFetching: Bool = false
    private var after: String?

    init(with service: FeedService = FeedService.shared, dataSource: GenericDataSource<Feed>?) {
        super.init()
        self.dataSource = dataSource
        self.dataSource?.delegate = self
        self.service = service
    }
    
    func fetchFeeds(after: String? = nil) {
        guard !isFetching else {
            print("Feeds already being fetched")
            return
        }
        guard let service = service else {
            onErrorHandling?(ErrorResult.custom(string: "No service available"))
            return
        }
        isFetching = true
        service.fetchFeeds(after: after) { (result) in
            self.isFetching = false
            DispatchQueue.global().async {
                switch result {
                case .success(let feeds):
                    self.after = feeds.after
                    self.dataSource?.data.value.append(contentsOf: feeds.data)
                case .failure(let error):
                    self.onErrorHandling?(error)
                }
            }
        }
    }
}

//MARK:- GenericDataSourceDelegate
extension FeedsViewModel: GenericDataSourceDelegate {
    func shouldFetchMoreFeeds() {
        fetchFeeds(after: self.after)
    }
}
