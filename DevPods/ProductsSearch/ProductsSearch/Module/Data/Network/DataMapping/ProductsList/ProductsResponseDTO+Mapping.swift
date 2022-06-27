//
//  ProductsResponseDTO+Mapping.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation

// MARK: - Data Transfer Object

struct ProductsResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case products = "results"
    }
    let products: [ProductDTO]
    
}

extension ProductsResponseDTO {
    struct ProductDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case title
            case price
            case thumbnail
        }
        let id: String?
        let title: String?
        let price: Int?
        let thumbnail: String?
    }
}

// MARK: - Mappings to Domain

extension ProductsResponseDTO {
    func toDomain() -> ProductsPage {
        return .init(products: products.map { $0.toDomain() }, page: 0)
    }
}

extension ProductsResponseDTO.ProductDTO {
    func toDomain() -> Product {
        
        return .init(id: id,
                     title: title,
                    price: price,
                     thumbnail: thumbnail)
    }
}




// MARK: - Private

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
