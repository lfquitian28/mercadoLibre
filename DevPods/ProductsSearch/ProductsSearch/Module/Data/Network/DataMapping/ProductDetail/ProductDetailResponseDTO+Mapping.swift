//
//  ProductDetailResponseDTO+Mapping.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 22/06/22.
//


import Foundation

// MARK: - Data Transfer Object

struct ProductsDetailBodyResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case body = "body"
    }
    let body: ProductDetailResponseDTO
}
extension ProductsDetailBodyResponseDTO{
    
    struct ProductDetailResponseDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case pictures = "pictures"
            case price
            case title
            case attributes = "attributes"
        }
        let id: String
        let pictures: [ListPicturesDTO]
        let price: Int?
        let title: String?
        let attributes: [ListAttributesDTO]
    }
}


extension ProductsDetailBodyResponseDTO.ProductDetailResponseDTO {
    struct ListPicturesDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case url
        }
        let id: String?
        let url: String?
    }
    
    struct ListAttributesDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case name
            case value_name
        }
        let id: String?
        let name: String?
        let value_name: String?
    }
}

// MARK: - Mappings to Domain

extension ProductsDetailBodyResponseDTO {
    func toDomain() -> ProductDetailBody {
        return .init(body: body.toDomain() )
    }
}


extension ProductsDetailBodyResponseDTO.ProductDetailResponseDTO {
    func toDomain() -> ProductDetail {
        return .init(id: id, pictures: pictures.map { $0.toDomain() }, price: price, title: title, attributes: attributes.map { $0.toDomain() })
    }
}

extension ProductsDetailBodyResponseDTO.ProductDetailResponseDTO.ListPicturesDTO {
    func toDomain() -> ListPictures {
        
        return .init(id: id,
                     url: url)
    }
}

extension ProductsDetailBodyResponseDTO.ProductDetailResponseDTO.ListAttributesDTO{
    func toDomain() -> ListAttributes {
        
        return .init(id: id,
                     name: name,
                     value_name: value_name)
    }
}
