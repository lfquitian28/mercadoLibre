//
//  ProductDetailQueriesRepository.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 22/06/22.
//


import Foundation

protocol ProductDetailQueriesRepository {
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ProductDetailQuery], Error>) -> Void)
    func saveRecentQuery(query: ProductDetailQuery, completion: @escaping (Result<ProductDetailQuery, Error>) -> Void)
}
