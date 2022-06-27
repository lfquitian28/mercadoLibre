//
//  ProductDetailQueryUDS+Mapping.swift
//  Networking
//
//  Created by Luis Francisco Quitian Cabra on 22/06/22.
//

import Foundation

struct ProductDetailQueriesListUDS: Codable {
    var list: [ProductDetailQueryUDS]
}

struct ProductDetailQueryUDS: Codable {
    let ids: String
}

extension ProductDetailQueryUDS {
    init(productDetailQuery: ProductDetailQuery) {
        ids = productDetailQuery.ids
    }
}

extension ProductDetailQueryUDS {
    func toDomain() -> ProductDetailQuery {
        return .init(ids: ids)
    }
}
