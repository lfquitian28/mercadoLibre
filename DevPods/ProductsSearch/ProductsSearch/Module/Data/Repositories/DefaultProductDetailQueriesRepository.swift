//
//  DefaultProductDetailQueriesRepository.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 22/06/22.
//

import Foundation
import Networking

final class DefaultProductDetailQueriesRepository {
    
    private let dataTransferService: DataTransferService
    private var productDetailQueriesPersistentStorage: ProductDetailQueriesStorage
    
    init(dataTransferService: DataTransferService,
         productDetailQueriesPersistentStorage: ProductDetailQueriesStorage) {
        self.dataTransferService = dataTransferService
        self.productDetailQueriesPersistentStorage = productDetailQueriesPersistentStorage
    }
}

extension DefaultProductDetailQueriesRepository: ProductDetailQueriesRepository {
    
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ProductDetailQuery], Error>) -> Void) {
        return productDetailQueriesPersistentStorage.fetchRecentsQueries(maxCount: maxCount, completion: completion)
    }
    
    func saveRecentQuery(query: ProductDetailQuery, completion: @escaping (Result<ProductDetailQuery, Error>) -> Void) {
        productDetailQueriesPersistentStorage.saveRecentQuery(query: query, completion: completion)
    }
}

