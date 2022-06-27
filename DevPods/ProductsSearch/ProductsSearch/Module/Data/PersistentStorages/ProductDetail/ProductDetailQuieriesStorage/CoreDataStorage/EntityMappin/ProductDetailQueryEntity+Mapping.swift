//
//  ProductDetailQueryEntity+Mapping.swift
//  Networking
//
//  Created by Luis Francisco Quitian Cabra on 22/06/22.
//

import Foundation
import CoreData

extension ProductDetailQueryEntity {
    convenience init(productDetailQuery: ProductDetailQuery, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        ids = productDetailQuery.ids
        createdAt = Date()
    }
}

extension ProductDetailQueryEntity {
    func toDomain() -> ProductDetailQuery {
        return .init(ids: ids ?? "")
    }
}
