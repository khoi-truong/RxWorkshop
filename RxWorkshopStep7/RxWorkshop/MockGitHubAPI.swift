//
//  MockGitHubAPI.swift
//  RxWorkshop
//
//  Created by Khoi Truong Minh on 12/7/16.
//  Copyright © 2016 Khoi Truong Minh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct MockGitHubAPI {

    static func getRepositories(query: String, minimumStars: Int) -> Observable<[Repository]> {
        guard let repositories = repositories(fromContentOfFile: "github-response") else {
            return Observable.just([Repository]())
        }
        return Observable.just(repositories)
    }
    
}

fileprivate func repositories(fromContentOfFile fileName: String) -> [Repository]? {
    guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else { return nil }
    let url = URL(fileURLWithPath: path)

    do {
        let data = try Data(contentsOf: url)
        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: AnyObject]
        let items = json?["items"] as? [[String: AnyObject]]
        return items?.reduce([], appendRepository)
    } catch {
        print(error)
        return nil
    }
}

fileprivate func appendRepository(inputs: (accumulator: [Repository], repositoryDictionary: [String: AnyObject])) -> [Repository] {
    var results = inputs.accumulator
    if let repository = Repository(dictionary: inputs.repositoryDictionary) {
        results.append(repository)
    }
    return results
}
