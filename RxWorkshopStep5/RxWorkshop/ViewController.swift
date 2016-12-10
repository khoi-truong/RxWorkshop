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
//    var minimumStars: Variable<Int> { get }

    var searchDescription: Observable<String> { get }
    var results: Observable<String> { get }

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

        let minimumStars = starSlider.rx.value

        // TODO: [1] Bind slider's value to viewModel `minimumStars` for later uses

        // TODO: [2] Bind `minimumStars` from viewModel to `starLabel`

        // TODO: [3] See the magic reactive UI after completing the tasks

        viewModel.searchDescription
            .bindTo(descriptionLabel.rx.text)
            .addDisposableTo(disposeBag)

        viewModel.results
            .bindTo(resultLabel.rx.text)
            .addDisposableTo(disposeBag)
    }

}

