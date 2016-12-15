//
//  ViewController.swift
//  RxWorkshop
//
//  Created by Khoi Truong Minh on 12/7/16.
//  Copyright © 2016 Khoi Truong Minh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol ViewModelType {

    var query: Variable<String> { get }
    var minimumStars: Variable<Int> { get }

    var searchDescription: Observable<String> { get }
    var results: Observable<[SectionOfCustomData]> { get }

    var showEasterEggAlert: Observable<Void> { get }
}

struct SectionOfCustomData {
    var header: String
    var items: [Item]
}
extension SectionOfCustomData: SectionModelType {
    typealias Item = Repository
    
    init(original: SectionOfCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starSlider: UISlider!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var tbView: UITableView!
    
    let viewModel: ViewModelType = ViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure(viewModel: viewModel)
    }

    private func configure(viewModel: ViewModelType) {
        searchBar.rx.text.map { $0 ?? "" }
            .bindTo(viewModel.query)
            .addDisposableTo(disposeBag)

        starSlider.rx.value
            .map { Int($0) }
            .bindTo(viewModel.minimumStars)
            .addDisposableTo(disposeBag)

        viewModel.minimumStars
            .asObservable()
            .map { String($0) + " ★" }
            .bindTo(starLabel.rx.text)
            .addDisposableTo(disposeBag)

        viewModel.showEasterEggAlert
            .subscribe(onNext: { [weak self] in
                self?.showEasterEggAlert()
            })
            .addDisposableTo(disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>()
        
        dataSource.configureCell = { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell", for: ip)
            cell.textLabel?.text = "\(ip.row + 1): \(item.name) with \(item.starCount) 🌟"
            cell.detailTextLabel?.text = item.description
            return cell
        }
        dataSource.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].header
        }
        
        viewModel.results
            .bindTo(tbView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)

        searchBar.rx.searchButtonClicked.subscribe({_ in self.searchBar.resignFirstResponder()}).addDisposableTo(disposeBag)
    }

    private func showEasterEggAlert() {
        let alert = UIAlertController(
            title: "Congratulation",
            message: "You've learn about 'filter' function",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}



































