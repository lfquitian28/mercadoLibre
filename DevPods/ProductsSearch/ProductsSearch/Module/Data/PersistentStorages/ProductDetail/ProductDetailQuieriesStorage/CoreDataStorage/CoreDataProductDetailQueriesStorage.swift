//
//  CoreDataProductDetailQueriesStorage.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 22/06/22.
//

import Foundation
import CoreData

final class CoreDataProductDetailQueriesStorage {

    private let maxStorageLimit: Int
    private let coreDataStorage: CoreDataStorage

    init(maxStorageLimit: Int, coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.maxStorageLimit = maxStorageLimit
        self.coreDataStorage = coreDataStorage
    }
}

extension CoreDataProductDetailQueriesStorage: ProductDetailQueriesStorage {
    
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ProductDetailQuery], Error>) -> Void) {
        
        coreDataStorage.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = ProductDetailQueryEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: #keyPath(ProductDetailQueryEntity.createdAt),
                                                            ascending: false)]
                request.fetchLimit = maxCount
                let result = try context.fetch(request).map { $0.toDomain() }

                completion(.success(result))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func saveRecentQuery(query: ProductDetailQuery, completion: @escaping (Result<ProductDetailQuery, Error>) -> Void) {

        coreDataStorage.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            do {
                try self.cleanUpQueries(for: query, inContext: context)
                let entity = ProductDetailQueryEntity(productDetailQuery: query, insertInto: context)
                try context.save()

                completion(.success(entity.toDomain()))
            } catch {
                completion(.failure(CoreDataStorageError.saveError(error)))
            }
        }
    }
}

// MARK: - Private
extension CoreDataProductDetailQueriesStorage {

    private func cleanUpQueries(for query: ProductDetailQuery, inContext context: NSManagedObjectContext) throws {
        let request: NSFetchRequest = ProductDetailQueryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(ProductDetailQueryEntity.createdAt),
                                                    ascending: false)]
        var result = try context.fetch(request)

        removeDuplicates(for: query, in: &result, inContext: context)
        removeQueries(limit: maxStorageLimit - 1, in: result, inContext: context)
    }

    private func removeDuplicates(for query: ProductDetailQuery, in queries: inout [ProductDetailQueryEntity], inContext context: NSManagedObjectContext) {
        queries
            .filter { $0.ids == query.ids }
            .forEach { context.delete($0) }
        queries.removeAll { $0.ids == query.ids }
    }

    private func removeQueries(limit: Int, in queries: [ProductDetailQueryEntity], inContext context: NSManagedObjectContext) {
        guard queries.count > limit else { return }

        queries.suffix(queries.count - limit)
            .forEach { context.delete($0) }
    }
}

