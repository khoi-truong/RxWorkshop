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

protocol ViewModelType {

    var query: Variable<String> { get }
    var minimumStars: Variable<Int> { get }

    var searchDescription: Observable<String> { get }
    var results: Observable<String> { get }
    var showNoStarWarning: Observable<Void> { get }
    var showEasterEggAlert: Observable<Void> { get }

}

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var starSlider: UISlider!
    @IBOutlet weak var starLabel: UILabel!

    let viewModel: ViewModelType = ViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure(viewModel: viewModel)
    }

    private func configure(viewModel: ViewModelType) {
        searchBar.rx.text.orEmpty
            .bindTo(viewModel.query)
            .addDisposableTo(disposeBag)

        starSlider.rx.value
            .map { Int($0) }
            .bindTo(viewModel.minimumStars)
            .addDisposableTo(disposeBag)

        viewModel.searchDescription
            .bindTo(descriptionLabel.rx.text)
            .addDisposableTo(disposeBag)

        viewModel.minimumStars
            .asObservable()
            .map { String($0) + " ★" }
            .bindTo(starLabel.rx.text)
            .addDisposableTo(disposeBag)

        viewModel.results
            .bindTo(resultLabel.rx.text)
            .addDisposableTo(disposeBag)

        viewModel.showNoStarWarning
            .subscribe(onNext: { [weak self] in
                self?.showNowStarWarningAlert()
            })
            .addDisposableTo(disposeBag)

        viewModel.showEasterEggAlert
            .subscribe(onNext: { [weak self] in
                self?.showEasterEggAlert()
            })
            .addDisposableTo(disposeBag)
    }

    private func showNowStarWarningAlert() {
        let alert = UIAlertController(
            title: "Warning",
            message: "There would be so many repository results with less than 10 ★",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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

