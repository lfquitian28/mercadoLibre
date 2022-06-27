//
//  UserDefaultsProductDetailQueriesStorage.swift
//  Networking
//
//  Created by Luis Francisco Quitian Cabra on 22/06/22.
//

import Foundation

final class UserDefaultsProductDetailQueriesStorage {
    private let maxStorageLimit: Int
    private let recentsProductDetailQueriesKey = "recentsProductDetailQueries"
    private var userDefaults: UserDefaults
    
    init(maxStorageLimit: Int, userDefaults: UserDefaults = UserDefaults.standard) {
        self.maxStorageLimit = maxStorageLimit
        self.userDefaults = userDefaults
    }

    private func fetchProductDetailQuries() -> [ProductDetailQuery] {
        if let queriesData = userDefaults.object(forKey: recentsProductDetailQueriesKey) as? Data {
            if let productDetailQueryList = try? JSONDecoder().decode(ProductDetailQueriesListUDS.self, from: queriesData) {
                return productDetailQueryList.list.map { $0.toDomain() }
            }
        }
        return []
    }

    private func persist(productDetailQuries: [ProductDetailQuery]) {
        let encoder = JSONEncoder()
        let productDetailQueryUDSs = productDetailQuries.map(ProductDetailQueryUDS.init)
        if let encoded = try? encoder.encode(ProductDetailQueriesListUDS(list: productDetailQueryUDSs)) {
            userDefaults.set(encoded, forKey: recentsProductDetailQueriesKey)
        }
    }
}

extension UserDefaultsProductDetailQueriesStorage: ProductDetailQueriesStorage {

    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ProductDetailQuery], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            var queries = self.fetchProductDetailQuries()
            queries = queries.count < self.maxStorageLimit ? queries : Array(queries[0..<maxCount])
            completion(.success(queries))
        }
    }

    func saveRecentQuery(query: ProductDetailQuery, completion: @escaping (Result<ProductDetailQuery, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            var queries = self.fetchProductDetailQuries()
            self.cleanUpQueries(for: query, in: &queries)
            queries.insert(query, at: 0)
            self.persist(productDetailQuries: queries)

            completion(.success(query))
        }
    }
}


// MARK: - Private
extension UserDefaultsProductDetailQueriesStorage {

    private func cleanUpQueries(for query: ProductDetailQuery, in queries: inout [ProductDetailQuery]) {
        removeDuplicates(for: query, in: &queries)
        removeQueries(limit: maxStorageLimit - 1, in: &queries)
    }

    private func removeDuplicates(for query: ProductDetailQuery, in queries: inout [ProductDetailQuery]) {
        queries = queries.filter { $0 != query }
    }

    private func removeQueries(limit: Int, in queries: inout [ProductDetailQuery]) {
        queries = queries.count <= limit ? queries : Array(queries[0..<limit])
    }
}
