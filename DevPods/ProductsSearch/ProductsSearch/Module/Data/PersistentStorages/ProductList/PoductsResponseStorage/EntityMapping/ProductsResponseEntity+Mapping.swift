//
//  ProductsResponseEntity+Mapping.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation
import CoreData

extension ProductsResponseEntity {
    func toDTO() -> ProductsResponseDTO {
        return .init(products: products?.allObjects.map { ($0 as! ProductResponseEntity).toDTO() } ?? [])
    }
}

extension ProductResponseEntity {
    func toDTO() -> ProductsResponseDTO.ProductDTO {
        return .init(id: id,
                     title: title,
                     price: Int(price),
                     thumbnail: thumbnail)
    }
}

extension ProductsRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> ProductsRequestEntity {
        let entity: ProductsRequestEntity = .init(context: context)
        entity.query = q
        return entity
    }
}

extension ProductsResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> ProductsResponseEntity {
        let entity: ProductsResponseEntity = .init(context: context)
        entity.page = 0
        products.forEach {
            entity.addToProducts($0.toEntity(in: context))
        }
        return entity
    }
}

extension ProductsResponseDTO.ProductDTO {
    func toEntity(in context: NSManagedObjectContext) -> ProductResponseEntity {
        let entity: ProductResponseEntity = .init(context: context)
        entity.id = id
        entity.title = title
        entity.price = Int64(price!)
        entity.thumbnail = thumbnail
        return entity
    }
}
