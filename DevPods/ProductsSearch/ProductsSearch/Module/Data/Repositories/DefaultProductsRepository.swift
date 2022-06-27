//
//  DefaultProductsRepository.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//
// **Note**: DTOs structs are mapped into Domains here, and Repository protocols does not contain DTOs

import Foundation
import Networking

final class DefaultProductsRepository {

    private let dataTransferService: DataTransferService
    private let cache: ProductsResponseStorage

    init(dataTransferService: DataTransferService, cache: ProductsResponseStorage) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}

extension DefaultProductsRepository: ProductsRepository {

    public func fetchProductsList(query: ProductQuery, 
                                cached: @escaping (ProductsPage) -> Void,
                                completion: @escaping (Result<ProductsPage, Error>) -> Void) -> Cancellable? {

        let requestDTO = ProductsRequestDTO(q: query.query)
        let task = RepositoryTask()

        cache.getResponse(for: requestDTO) { result in

            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
            }
            guard !task.isCancelled else { return }

            let endpoint = APIEndpoints.getProducts(with: requestDTO)
            
            task.networkTask = self.dataTransferService.request(with: endpoint) { result in
                switch result {
                case .success(let responseDTO):
                    self.cache.save(response: responseDTO, for: requestDTO)
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
}
