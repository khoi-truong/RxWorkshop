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
//    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchText = searchBar.rx.text.orEmpty

        let binding = searchText.map { "Searching for: " + $0.uppercased() }.bindTo(descriptionLabel.rx.text)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            // Release all the resources allocated to compute the upcoming `searchText` elements
            binding.dispose()
        })

        // When a DisposeBag is deallocated, it will call dispose on each of the added disposables
//        binding.addDisposableTo(disposeBag)

        // TODO: Add all the UI binding to disposeBag
        viewModel.results.bindTo(resultLabel.rx.text)
    }

}

