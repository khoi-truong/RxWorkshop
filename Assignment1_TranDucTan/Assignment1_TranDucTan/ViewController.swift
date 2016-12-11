//
//  ViewController.swift
//  Assignment1_TranDucTan
//
//  Created by Tan Tran on 12/11/16.
//  Copyright © 2016 Tan Tran. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var starSlider: UISlider!
    @IBOutlet weak var searchDescription: UILabel!
    @IBOutlet weak var searchResultTable: UITableView!
    
    var reposData = [RepositoryData]()
    var resultSections = [SectionOfRepositoryData]()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let searchRepo = searchBar
            .rx
            .text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
        
        let searchStar = starSlider
            .rx
            .value
            .map({ Int($0) })
            .debounce(0.5, scheduler: MainScheduler.instance)
        
        let searchQuery = Observable
            .combineLatest(searchRepo, searchStar, resultSelector: { ($0, $1) })
            .flatMapLatest(fromQueryAndStarsToSearchResults)
        
        searchQuery
            .map(fromSearchResultsToSearchDescription)
            .observeOn(MainScheduler.instance)
            .bindTo(searchDescription.rx.text)
            .addDisposableTo(disposeBag)
        
        searchStar
            .map({ String($0) + " ⭐️" })
            .bindTo(starLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        
        let resultDataSource = RxTableViewSectionedReloadDataSource<SectionOfRepositoryData>()
        resultDataSource.configureCell = { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            let repoNameLabel = cell.viewWithTag(1) as! UILabel
            let repoStarCountLabel = cell.viewWithTag(2) as! UILabel
            let repoDescriptionLabel = cell.viewWithTag(3) as! UILabel
            
            repoNameLabel.text = "📦 " + item.ownerName + "/" + item.name
            repoStarCountLabel.text = String(item.starCount) + " ⭐️"
            repoDescriptionLabel.text = item.description
            
            return cell
        }
        resultDataSource.titleForHeaderInSection = { dataSource, indexPath in
            return dataSource.sectionModels[indexPath].header
        }
        
        searchQuery
            .map({ $0.0 })
            .map(fromRepositoriesToDataSource)
            .map({ return [SectionOfRepositoryData(header: "", items: $0)] })
            .observeOn(MainScheduler.instance)
            .bindTo(searchResultTable.rx.items(dataSource: resultDataSource))
            .addDisposableTo(disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


//Functions Callback
extension ViewController {
    func fromQueryAndStarsToSearchResults(inputs: (query: String, minimumStars: Int)) -> Observable<([Repository], String, Int)> {
        return GitHubAPI
            .getRepositories(query: inputs.query, minimumStars: inputs.minimumStars)
            .catchErrorJustReturn([])
            .withLatestFrom(Observable.just((inputs.query, inputs.minimumStars))) { ($0.0, $0.1.0, $0.1.1) }
    }
    
    func fromSearchResultsToSearchDescription(inputs: (repositories: [Repository], query: String, minimumStars: Int)) -> String {
        if inputs.repositories.count == 0 {
            return "We've found \(inputs.repositories.count) repository result for '\(inputs.query)' with more than \(inputs.minimumStars) stars. This may cause of exceeding 10 non authenticated GitHub API requests per minute. Please wait a minute. :(\nhttps://developer.github.com/v3/#rate-limiting"
        } else {
            return "We've found \(inputs.repositories.count) repository results for '\(inputs.query)' with more than \(inputs.minimumStars) stars."
        }
    }
    
    func fromRepositoriesToDataSource(repos: [Repository]) -> [RepositoryData] {
        return repos.map({ repo in
            return RepositoryData(name: repo.name, ownerName: repo.owner.login, description: repo.description, starCount: repo.starCount)
        })
    }
}

