//
//  ViewModel.swift
//  RxWorkshop
//
//  Created by Khoi Truong Minh on 12/7/16.
//  Copyright © 2016 Khoi Truong Minh. All rights reserved.
//

import Foundation

struct ViewModel: ViewModelType {

    var results: String {
        return getDescriptionFromRepositories(repos: MockGitHubAPI.getRepositories())
    }

}

fileprivate func getDescription(repository: Repository) -> String {
    return "\(repository.id) - \(repository.name) - \(repository.starCount) ⭐️\n"
}

var fromRepositoryToString = getDescription

fileprivate func hasEnoughStars(repository: Repository) -> Bool {
    return repository.starCount > 250
}

fileprivate func moreStars(first: Repository, second: Repository) -> Bool {
    return first.starCount > second.starCount
}

fileprivate func getDescriptionFromRepositories(repos: [Repository]) -> String {
    return repos
        .filter(hasEnoughStars)
        .sorted(by: moreStars)
        .map(fromRepositoryToString)
        .reduce("", +)
}

//fileprivate func getDescriptionFromRepositories(repos: [Repository]) -> String {
//    return repos
//        .filter(hasEnoughStars)
//        .sorted(by: moreStars)
//        .reduce("", { (result, repo) -> String in
//            return result + "\(repo.id) - \(repo.name) - \(repo.starCount) ⭐️\n"
//        })
//}

//fileprivate func getDescriptionFromRepositories(repos: [Repository]) -> String {
//    return repos
//        .filter(hasEnoughStars)
//        .sorted(by: moreStars)
//        .map(fromRepositoryToString)
//        .reduce("", { (result, string) in
//            return result + string
//        })
//}

