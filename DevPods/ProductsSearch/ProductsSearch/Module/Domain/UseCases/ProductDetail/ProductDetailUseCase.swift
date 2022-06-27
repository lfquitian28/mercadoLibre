//
//  ProductDetailUseCase.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation

protocol ProductDetailUseCase {
    func execute(requestValue: SearchProductDetailUseCaseRequestValue,
                 cached: @escaping (ProductDetailBody) -> Void,
                 completion: @escaping (Result<ProductDetailBody, Error>) -> Void) -> Cancellable?
}

final class DefaultProductDetailUseCase: ProductDetailUseCase {

    private let productDetailRepository: ProductDetailRepository
    private let productDetailQueriesRepository: ProductDetailQueriesRepository

    init(productDetailRepository: ProductDetailRepository,
         productDetailQueriesRepository: ProductDetailQueriesRepository) {

        self.productDetailRepository = productDetailRepository
        self.productDetailQueriesRepository = productDetailQueriesRepository
    }

    func execute(requestValue: SearchProductDetailUseCaseRequestValue,
                 cached: @escaping (ProductDetailBody) -> Void,
                 completion: @escaping (Result<ProductDetailBody, Error>) -> Void) -> Cancellable? {

        return productDetailRepository.fetchProductDetail(query: requestValue.ids,
                                                cached: cached) { result in

            if case .success = result {
                self.productDetailQueriesRepository.saveRecentQuery(query: requestValue.ids) { _ in }
            }

            completion(result)
        }
    }
}

struct SearchProductDetailUseCaseRequestValue {
    let ids: ProductDetailQuery
}
