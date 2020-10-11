//
//  ViewController.swift
//  RedditClient
//
//  Created by Ram Jalla on 09/10/20.
//

import UIKit

class ViewController: UIViewController {

    let dataSource = FeedsDataSource()
    
    var tableView: UITableView?
    
    lazy var viewModel: FeedsViewModel = {
        let model = FeedsViewModel(dataSource: dataSource)
        return model
    }()
    
    override func loadView() {
        super.loadView()
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView!)
        tableView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView?.register(FeedTableViewCell.self, forCellReuseIdentifier: "feedCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.dataSource = self.dataSource
        tableView?.delegate = self.dataSource
        self.viewModel.dataSource?.data.addAndNotify(observer: self, completionHandler: { (feeds) in
            OperationQueue.main.addOperation {
                self.tableView?.reloadData()
            }
        })
        
        self.viewModel.onErrorHandling = { [weak self] error in
            let controller = UIAlertController(title: "An error occured", message: "Oops, something went wrong!", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self?.present(controller, animated: true, completion: nil)
        }
        
        self.viewModel.fetchFeeds()
        
    }


}

