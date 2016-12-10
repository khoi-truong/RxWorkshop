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
    var minimumStars: Variable<Int> = Variable<Int>(500)

    let searchDescription: Observable<String>
    let results: Observable<String>
    let showNoStarWarning: Observable<Void>
    let showEasterEggAlert: Observable<Void>

    init() {
        let combineQueryAndMinimumStars: Observable<(String, Int)> = Observable.combineLatest(query.asObservable(), minimumStars.asObservable()) { ($0, $1) }

        searchDescription = combineQueryAndMinimumStars
            .flatMapLatest(toSearchDescription)
            .observeOn(MainScheduler.instance)

        results = combineQueryAndMinimumStars
            .flatMapLatest { (query, minimumStars) in
                MockGitHubAPI
                    .getRepositories(query: query, minimumStars: minimumStars)
                    .map(toString)
        }

        showNoStarWarning = minimumStars.asObservable()
            .filter { $0 < 10 }
            .map { _ in }
            .take(1)

        showEasterEggAlert = query.asObservable()
            .filter { $0.lowercased() == "rxswift" }
            .map { _ in }
            .take(1)
    }

}

fileprivate func toSearchDescription(inputs: (query: String, minimumStars: Int)) -> Observable<String> {
    return Observable.just("Repository results for '\(inputs.query)' with more than \(inputs.minimumStars) stars.")
}

fileprivate func toString(repos: [Repository]) -> String {
    return repos.reduce("", { (result, repo) -> String in
        return result + "\n"
            + "📦 " + repo.owner.login + "/" + repo.name + "\n"
            + "⭐️ " + String(repo.starCount) + "\n"
            + "     " + repo.description + "\n" + "\n\n"
            + "----------------------" + "\n"
    })
}
