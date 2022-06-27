//
//  CoreDataProductsResponseStorage.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation
import CoreData

final class CoreDataProductsResponseStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private

    private func fetchRequest(for requestDto: ProductsRequestDTO) -> NSFetchRequest<ProductsRequestEntity> {
        let request: NSFetchRequest = ProductsRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@ ",
                                        #keyPath(ProductsRequestEntity.query), requestDto.q)
        return request
    }

    private func deleteResponse(for requestDto: ProductsRequestDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest(for: requestDto)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}

extension CoreDataProductsResponseStorage: ProductsResponseStorage {

    func getResponse(for requestDto: ProductsRequestDTO, completion: @escaping (Result<ProductsResponseDTO?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: requestDto)
                let requestEntity = try context.fetch(fetchRequest).first

                completion(.success(requestEntity?.response?.toDTO()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }

    func save(response responseDto: ProductsResponseDTO, for requestDto: ProductsRequestDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: requestDto, in: context)

                let requestEntity = requestDto.toEntity(in: context)
                requestEntity.response = responseDto.toEntity(in: context)

                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataProductsResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
