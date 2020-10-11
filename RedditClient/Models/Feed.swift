//
//  Feed.swift
//  RedditClient
//
//  Created by Ram Jalla on 09/10/20.
//

import Foundation

struct Feeds: Codable {
    var after: String?
    var data: [Feed]
}

extension Feeds: Parceable {
    static func parseObject(dictionary: [String : Any]) -> Result<Feeds, ErrorResult> {
        guard let data = dictionary["data"] as? [String : Any], let childrens = data["children"] as? [[String : Any]] else {
            return .failure(.parser(string: "Unable to parse feeds"))
        }
        var feeds = [Feed]()
        for children in childrens {
            if let dict = children["data"] as? [String : Any] {
                feeds.append(Feed(with: dict))
            }
        }
        return .success(Feeds(after: data["after"] as? String, data: feeds))
    }
}

struct Feed: Codable {
    var title: String?
    var commentsCount: Int?
    var score: Int?
    var thumbnail: Thumbnail?
    
    init(with dict: [String : Any]) {
        title = dict["title"] as? String
        commentsCount = dict["num_comments"] as? Int
        score = dict["score"] as? Int
        thumbnail = Thumbnail(url: dict["thumbnail"] as? String, width: dict["thumbnail_height"] as? Int, height: dict["thumbnail_width"] as? Int)
    }
}
