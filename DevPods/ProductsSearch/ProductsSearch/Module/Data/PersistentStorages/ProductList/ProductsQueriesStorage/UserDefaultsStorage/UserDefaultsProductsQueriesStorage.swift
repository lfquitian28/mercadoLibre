//
//  UserDefaultsProductsQueriesStorage.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation

final class UserDefaultsProductsQueriesStorage {
    private let maxStorageLimit: Int
    private let recentsProductsQueriesKey = "recentsProductsQueries"
    private var userDefaults: UserDefaults
    
    init(maxStorageLimit: Int, userDefaults: UserDefaults = UserDefaults.standard) {
        self.maxStorageLimit = maxStorageLimit
        self.userDefaults = userDefaults
    }

    private func fetchProductsQuries() -> [ProductQuery] {
        if let queriesData = userDefaults.object(forKey: recentsProductsQueriesKey) as? Data {
            if let productQueryList = try? JSONDecoder().decode(ProductQueriesListUDS.self, from: queriesData) {
                return productQueryList.list.map { $0.toDomain() }
            }
        }
        return []
    }

    private func persist(productsQuries: [ProductQuery]) {
        let encoder = JSONEncoder()
        let productQueryUDSs = productsQuries.map(ProductQueryUDS.init)
        if let encoded = try? encoder.encode(ProductQueriesListUDS(list: productQueryUDSs)) {
            userDefaults.set(encoded, forKey: recentsProductsQueriesKey)
        }
    }
}

extension UserDefaultsProductsQueriesStorage: ProductsQueriesStorage {

    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ProductQuery], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            var queries = self.fetchProductsQuries()
            queries = queries.count < self.maxStorageLimit ? queries : Array(queries[0..<maxCount])
            completion(.success(queries))
        }
    }

    func saveRecentQuery(query: ProductQuery, completion: @escaping (Result<ProductQuery, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            var queries = self.fetchProductsQuries()
            self.cleanUpQueries(for: query, in: &queries)
            queries.insert(query, at: 0)
            self.persist(productsQuries: queries)

            completion(.success(query))
        }
    }
}


// MARK: - Private
extension UserDefaultsProductsQueriesStorage {

    private func cleanUpQueries(for query: ProductQuery, in queries: inout [ProductQuery]) {
        removeDuplicates(for: query, in: &queries)
        removeQueries(limit: maxStorageLimit - 1, in: &queries)
    }

    private func removeDuplicates(for query: ProductQuery, in queries: inout [ProductQuery]) {
        queries = queries.filter { $0 != query }
    }

    private func removeQueries(limit: Int, in queries: inout [ProductQuery]) {
        queries = queries.count <= limit ? queries : Array(queries[0..<limit])
    }
}
