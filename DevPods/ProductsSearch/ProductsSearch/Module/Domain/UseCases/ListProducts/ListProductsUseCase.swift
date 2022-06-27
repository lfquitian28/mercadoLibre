//
//  ListProductsUseCase.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation

protocol ListProductsUseCase {
    func execute(requestValue: SearchProductsUseCaseRequestValue,
                 cached: @escaping (ProductsPage) -> Void,
                 completion: @escaping (Result<ProductsPage, Error>) -> Void) -> Cancellable?
}

final class DefaultSearchProductsUseCase: ListProductsUseCase {

    private let productsRepository: ProductsRepository
    private let productsQueriesRepository: ProductsQueriesRepository

    init(productsRepository: ProductsRepository,
         productsQueriesRepository: ProductsQueriesRepository) {

        self.productsRepository = productsRepository
        self.productsQueriesRepository = productsQueriesRepository
    }

    func execute(requestValue: SearchProductsUseCaseRequestValue,
                 cached: @escaping (ProductsPage) -> Void,
                 completion: @escaping (Result<ProductsPage, Error>) -> Void) -> Cancellable? {

        return productsRepository.fetchProductsList(query: requestValue.query,
                                                cached: cached) { result in

            if case .success = result {
                self.productsQueriesRepository.saveRecentQuery(query: requestValue.query) { _ in }
            }

            completion(result)
        }
    }
}

struct SearchProductsUseCaseRequestValue {
    let query: ProductQuery
    let page: Int
}


