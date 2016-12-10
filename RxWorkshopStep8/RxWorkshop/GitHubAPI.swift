//
//  GitHubAPI.swift
//  RxWorkshop
//
//  Created by Khoi Truong Minh on 12/7/16.
//  Copyright © 2016 Khoi Truong Minh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum GitHubAPIError: Error {
    case invalidURL(String)
    case mappingError
}

struct GitHubAPI {

    static func getRepositories(query: String, minimumStars: Int) -> Observable<[Repository]> {
        var query = "https://api.github.com/search/repositories?q=\(query)+stars:>=\(minimumStars)&sort=stars&order=desc"
        query = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        guard let url = URL(string: query) else {
            return Observable.error(GitHubAPIError.invalidURL(query))
        }
        let request = URLRequest(url: url)

        return URLSession.shared.rx
            .json(request: request)
            .map { json in
                guard let json = json as? [String: AnyObject] else {
                    throw GitHubAPIError.mappingError
                }
                guard let items = json["items"] as? [[String: AnyObject]] else {
                    throw GitHubAPIError.mappingError
                }
                return [Repository]()
                // TODO: [2] Tranform `json` into repository array using `map`, `filter`, `reduce`
        }
    }

}
