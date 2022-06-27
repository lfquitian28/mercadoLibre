//
//  ProductQueryUDS+Mapping.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation

struct ProductQueriesListUDS: Codable {
    var list: [ProductQueryUDS]
}

struct ProductQueryUDS: Codable {
    let query: String
}

extension ProductQueryUDS {
    init(productQuery: ProductQuery) {
        query = productQuery.query
    }
}

extension ProductQueryUDS {
    func toDomain() -> ProductQuery {
        return .init(query: query)
    }
}
