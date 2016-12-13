//
//  DataSource.swift
//  Assignment1_TranDucTan
//
//  Created by Tan Tran on 12/11/16.
//  Copyright © 2016 Tan Tran. All rights reserved.
//

import Foundation
import RxDataSources

struct RepositoryData {
    var name: String
    var ownerName: String
    var description: String
    var starCount: Int
}

struct SectionOfRepositoryData {
    var header: String
    var items: [Item]
}

extension SectionOfRepositoryData: SectionModelType {
    typealias Item = RepositoryData
    
    init(original: SectionOfRepositoryData, items: [Item]) {
        self = original
        self.items = items
    }
}
