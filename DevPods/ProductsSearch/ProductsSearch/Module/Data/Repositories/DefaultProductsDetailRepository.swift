//
//  DefaultProductDetailRepository.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 22/06/22.
//

import Foundation
import Networking

final class DefaultProductsDetailRepository {

    private let dataTransferService: DataTransferService
    private let cache: ProductDetailResponseStorage

    init(dataTransferService: DataTransferService, cache: ProductDetailResponseStorage) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}

extension DefaultProductsDetailRepository: ProductDetailRepository {

    public func fetchProductDetail(query: ProductDetailQuery,
                                cached: @escaping (ProductDetailBody) -> Void,
                                completion: @escaping (Result<ProductDetailBody, Error>) -> Void) -> Cancellable? {

        let requestDTO = ProductDetailRequestDTO(ids: query.ids)
        let task = RepositoryTask()

        cache.getResponse(for: requestDTO) { result in

            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
            }
            guard !task.isCancelled else { return }

            let endpoint = APIEndpoints.getProductDetail(with: requestDTO)
            
            task.networkTask = self.dataTransferService.request(with: endpoint) { result in
                switch result {
                case .success(let responseDTO):
                    self.cache.save(response: responseDTO[0], for: requestDTO)
                    completion(.success(responseDTO[0].toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
}
