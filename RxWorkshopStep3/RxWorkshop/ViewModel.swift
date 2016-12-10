//
//  ViewModel.swift
//  RxWorkshop
//
//  Created by Khoi Truong Minh on 12/7/16.
//  Copyright © 2016 Khoi Truong Minh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ViewModel: ViewModelType {

    var results: Observable<String> {
        let repositories = MockGitHubAPI.getRepositories()
        // TODO: [3] Transform repositories into a string
        return Observable.just("Mock search results")
    }

}

fileprivate func toString(repos: [Repository]) -> String {
    return repos
        .filter { $0.starCount > 250 }
        .sorted(by: { (lhs, rhs) -> Bool in
            return lhs.starCount > rhs.starCount
        })
        .map { "\($0.name) - \($0.starCount) ⭐️\n" }
        .reduce("", +)
}
