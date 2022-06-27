//
//  APIEndpoints.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation
import Networking


struct APIEndpoints {
    
    static func getProducts(with productsRequestDTO: ProductsRequestDTO) -> Endpoint<ProductsResponseDTO> {
        
        return Endpoint(path: "/sites/MCO/search?",
                        method: .get,
                        queryParametersEncodable: productsRequestDTO)
    }
    
    static func getProductDetail(with productDetailRequestDTO: ProductDetailRequestDTO) -> Endpoint<[ProductsDetailBodyResponseDTO]> {
        
        return Endpoint(path: "items?",
                        method: .get,
                        queryParametersEncodable: productDetailRequestDTO)
    }
}
