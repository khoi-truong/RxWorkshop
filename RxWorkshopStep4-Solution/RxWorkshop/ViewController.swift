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

    var results: Observable<String> { get }

}

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!

    let viewModel: ViewModelType = ViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.rx.text.orEmpty
            .map { "Searching for: " + $0.uppercased() }
            .bindTo(descriptionLabel.rx.text)
            .addDisposableTo(disposeBag)

        viewModel.results
            .bindTo(resultLabel.rx.text)
            .addDisposableTo(disposeBag)
    }

}

