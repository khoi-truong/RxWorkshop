//
//  ViewController.swift
//  RxWorkshop
//
//  Created by Khoi Truong Minh on 12/7/16.
//  Copyright © 2016 Khoi Truong Minh. All rights reserved.
//

// STEP 2

import UIKit

protocol ViewModelType {

    var results: String { get }

}

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!

    let viewModel: ViewModelType = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure(viewModel: viewModel)
    }

    private func configure(viewModel: ViewModelType) {
        resultLabel.text = viewModel.results
    }

}

