//
//  CoreDataProductDetailResponseStorage.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 22/06/22.
//

import Foundation
import CoreData

final class CoreDataProductDetailResponseStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private

    private func fetchRequest(for requestDto: ProductDetailRequestDTO) -> NSFetchRequest<ProductsDetailRequestEntity> {
        let request: NSFetchRequest = ProductsDetailRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@ ",
                                        #keyPath(ProductsDetailRequestEntity.ids), requestDto.ids)
        return request
    }

    private func deleteResponse(for requestDto: ProductDetailRequestDTO, in context: NSManagedObjectContext) {
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

extension CoreDataProductDetailResponseStorage: ProductDetailResponseStorage {

    func getResponse(for requestDto: ProductDetailRequestDTO, completion: @escaping (Result<ProductsDetailBodyResponseDTO?, CoreDataStorageError>) -> Void) {
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
    
    func save(response responseDto: ProductsDetailBodyResponseDTO, for requestDto: ProductDetailRequestDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: requestDto, in: context)

                let requestEntity = requestDto.toEntity(in: context)
                requestEntity.response = responseDto.toEntity(in: context)

                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataProductDetailResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
