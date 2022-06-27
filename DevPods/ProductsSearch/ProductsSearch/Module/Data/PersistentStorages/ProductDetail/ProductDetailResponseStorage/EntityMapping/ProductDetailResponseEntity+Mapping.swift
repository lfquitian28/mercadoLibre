//
//  ProductDetailResponseEntity.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 22/06/22.
//

import Foundation
import CoreData

extension ProductsDetailBodyResponseEntity{
    func toDTO() -> ProductsDetailBodyResponseDTO{
        return .init(body: (body?.toDTO())!)
    }
}

extension ProductsDetailResponseEntity {
    func toDTO() -> ProductsDetailBodyResponseDTO.ProductDetailResponseDTO {
        return .init(id: id ?? "", pictures: pictures?.allObjects.map { ($0 as! ProductDetailPicturesResponseEntity).toDTO() } ?? [], price: Int(price), title: title ?? "", attributes: attributes?.allObjects.map { ($0 as! ProductDetailAtributeResponseEntity).toDTO() } ?? [])
    }
}


extension ProductDetailPicturesResponseEntity {
    func toDTO() -> ProductsDetailBodyResponseDTO.ProductDetailResponseDTO.ListPicturesDTO {
        return .init(id: id,
                     url: url)
    }
}

extension ProductDetailAtributeResponseEntity {
    func toDTO() -> ProductsDetailBodyResponseDTO.ProductDetailResponseDTO.ListAttributesDTO {
        return .init(id: id, name: name, value_name: value_name)
    }
}

extension ProductDetailRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> ProductsDetailRequestEntity {
        let entity: ProductsDetailRequestEntity = .init(context: context)
        entity.ids = ids
        return entity
    }
}

extension ProductsDetailBodyResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> ProductsDetailBodyResponseEntity {
        let entity: ProductsDetailBodyResponseEntity = .init(context: context)
        entity.body = body.toEntity(in: context)
        
        return entity
    }
}


extension ProductsDetailBodyResponseDTO.ProductDetailResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> ProductsDetailResponseEntity {
        let entity: ProductsDetailResponseEntity = .init(context: context)
        entity.id = id
        pictures.forEach {
            entity.addToPictures($0.toEntity(in: context))
        }
        entity.price = Int64(price ?? 0)
        entity.title = title
        attributes.forEach {
            entity.addToAttributes($0.toEntity(in: context))
        }
        
        return entity
    }
}

extension ProductsDetailBodyResponseDTO.ProductDetailResponseDTO.ListPicturesDTO {
    
    func toEntity(in context: NSManagedObjectContext) -> ProductDetailPicturesResponseEntity {
        let entity: ProductDetailPicturesResponseEntity = .init(context: context)
        entity.id = id
        entity.url = url
        return entity
    }
    
}

extension ProductsDetailBodyResponseDTO.ProductDetailResponseDTO.ListAttributesDTO {
    
    func toEntity(in context: NSManagedObjectContext) -> ProductDetailAtributeResponseEntity {
        let entity: ProductDetailAtributeResponseEntity = .init(context: context)
        entity.id = id
        entity.name = name
        entity.value_name = value_name
        return entity
    }
    
}
