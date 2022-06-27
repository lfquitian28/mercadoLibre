//
//  ProductDetailRepository.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 22/06/22.
//


import Foundation

protocol ProductDetailRepository {
    
    func fetchProductDetail(query: ProductDetailQuery, 
                         cached: @escaping (ProductDetailBody) -> Void,
                         completion: @escaping (Result<ProductDetailBody, Error>) -> Void) -> Cancellable?
}
