//
//  ParseHelper.swift
//  RedditClient
//
//  Created by Ram Jalla on 10/10/20.
//

import Foundation
protocol Parceable {
    static func parseObject(dictionary : [String : Any]) -> Result<Self, ErrorResult>
}

final class ParseHelper {
    static func parse<T: Parceable>(data: Data, completion: (Result<T, ErrorResult>) -> Void) {
        do {
            guard let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else {
                completion(.failure(.parser(string: "Errro while parsing data: Json is not a dictionary")))
                return
            }
            switch T.parseObject(dictionary: result) {
            case .success(let newValue):
                completion(.success(newValue))
            case .failure(let error):
                completion(.failure(.parser(string: "Errro while parsing data: \(error.localizedDescription)")))
            }
        }catch {
            completion(.failure(.parser(string: "Errro while parsing data: \(error.localizedDescription)")))
        }
    }
}

