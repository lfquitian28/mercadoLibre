//
//  ProductQueryEntity+Mapping.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation
import CoreData

extension ProductQueryEntity {
    convenience init(productQuery: ProductQuery, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        query = productQuery.query
        createdAt = Date()
    }
}

extension ProductQueryEntity {
    func toDomain() -> ProductQuery {
        return .init(query: query ?? "")
    }
}
