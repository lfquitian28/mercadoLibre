//
//  ProductsQueriesStorage.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation

protocol ProductsQueriesStorage {
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ProductQuery], Error>) -> Void)
    func saveRecentQuery(query: ProductQuery, completion: @escaping (Result<ProductQuery, Error>) -> Void)
}
