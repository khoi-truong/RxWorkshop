//
//  MockGitHubAPI.swift
//  RxWorkshop
//
//  Created by Khoi Truong Minh on 12/7/16.
//  Copyright © 2016 Khoi Truong Minh. All rights reserved.
//

import Foundation

struct MockGitHubAPI {

    static func getRepositories() -> [Repository] {
        return [
            Repository(id: 1, name: "RxOptional", starCount: 208),
            Repository(id: 2, name: "RxViewModel", starCount: 191),
            Repository(id: 3, name: "RxDataSources", starCount: 378),
            Repository(id: 4, name: "Action", starCount: 224),
            Repository(id: 5, name: "RxSwift", starCount: 7011)
        ]
    }

}
