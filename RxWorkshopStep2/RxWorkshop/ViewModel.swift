//
//  ViewModel.swift
//  RxWorkshop
//
//  Created by Khoi Truong Minh on 12/7/16.
//  Copyright © 2016 Khoi Truong Minh. All rights reserved.
//

import Foundation

struct ViewModel: ViewModelType {

    var results: String
        // TODO: [1] Get repositories from mock API; convert them to a string that contains all repository infos (id + name + starCount), separated by new line

        // TODO: [2] Sort repositories by `starCount`

        // TODO: [3] Results should contain only name of repositories which have more than 250 stars

    init() {
        results = ""
        toString(repos: MockGitHubAPI.getRepositories())
    }

    mutating func toString(repos: [Repository]) {
        /*:

         ### Avoiding Mutability

         Mutability and state are commonly used arguments for functional programming. However, state exists in the real world and, when writing applications, is an unavoidable problem.

         The key to mutability is to _avoid_ it, but understand that it's not always possible. Pick your battles. Try to avoid code that changes state, especially global state. Don't do this:

         */

        for repo in repos {
            if repo.starCount > 250 {
                results = results + "\(repo.id) - \(repo.name) - \(repo.starCount) ⭐️\n"
            }
        }
    }

}
