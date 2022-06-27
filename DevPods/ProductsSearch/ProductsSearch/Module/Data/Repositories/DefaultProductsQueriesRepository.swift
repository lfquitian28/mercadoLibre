//
//  DefaultProductsQueriesRepository.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation
import Networking

final class DefaultProductsQueriesRepository {
    
    private let dataTransferService: DataTransferService
    private var productsQueriesPersistentStorage: ProductsQueriesStorage
    
    init(dataTransferService: DataTransferService,
         productsQueriesPersistentStorage: ProductsQueriesStorage) {
        self.dataTransferService = dataTransferService
        self.productsQueriesPersistentStorage = productsQueriesPersistentStorage
    }
}

extension DefaultProductsQueriesRepository: ProductsQueriesRepository {
    
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ProductQuery], Error>) -> Void) {
        return productsQueriesPersistentStorage.fetchRecentsQueries(maxCount: maxCount, completion: completion)
    }
    
    func saveRecentQuery(query: ProductQuery, completion: @escaping (Result<ProductQuery, Error>) -> Void) {
        productsQueriesPersistentStorage.saveRecentQuery(query: query, completion: completion)
    }
}

