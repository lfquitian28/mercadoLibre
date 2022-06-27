//
//  ProductsRepository.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation

protocol ProductsRepository {
    
    func fetchProductsList(query: ProductQuery, 
                         cached: @escaping (ProductsPage) -> Void,
                         completion: @escaping (Result<ProductsPage, Error>) -> Void) -> Cancellable?
}
