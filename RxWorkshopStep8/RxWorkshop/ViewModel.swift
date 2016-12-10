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

    let query: Variable<String> = Variable<String>("")
    let minimumStars: Variable<Int> = Variable<Int>(0)
    let searchDescription: Observable<String>
    let results: Observable<String>
    let showEasterEggAlert: Observable<Void>

    init() {
        let debouncedQuery = query
            .asObservable()
            .debounce(0.5, scheduler: MainScheduler.instance)

        let debouncedStars = minimumStars
            .asObservable()
            .debounce(0.5, scheduler: MainScheduler.instance)

        let searchResults = Observable
            .combineLatest(debouncedQuery, debouncedStars) { ($0, $1) }
            .flatMapLatest(fromQueryAndStarsToSearchResults)

        searchDescription = searchResults
            .map(fromSearchResultsToSearchDescription)

        results = searchResults
            .map { $0.0 }
            .map(fromRepositoriesToString)

        showEasterEggAlert = query.asObservable()
            .filter { $0.lowercased() == "rxswift" }
            .map { _ in }
            .take(1)
    }

}

fileprivate func fromQueryAndStarsToSearchResults(inputs: (query: String, minimumStars: Int)) -> Observable<([Repository], String, Int)> {
    // TODO: [1] Replace Mock API by real API
    return MockGitHubAPI
        .getRepositories(query: inputs.query, minimumStars: inputs.minimumStars)
        .withLatestFrom(Observable.just((inputs.query, inputs.minimumStars))) { ($0.0, $0.1.0, $0.1.1) }
}

fileprivate func fromSearchResultsToSearchDescription(inputs: (repositories: [Repository], query: String, minimumStars: Int)) -> String {
    return "We've found \(inputs.repositories.count) repository results for '\(inputs.query)' with more than \(inputs.minimumStars) stars."
}

fileprivate func fromRepositoriesToString(repos: [Repository]) -> String {
    return repos.reduce("", { (result, repo) -> String in
        return result + "\n"
            + "📦 " + repo.owner.login + "/" + repo.name + "\n"
            + "⭐️ " + String(repo.starCount) + "\n"
            + "     " + repo.description + "\n" + "\n\n"
            + "----------------------" + "\n"
    })
}
