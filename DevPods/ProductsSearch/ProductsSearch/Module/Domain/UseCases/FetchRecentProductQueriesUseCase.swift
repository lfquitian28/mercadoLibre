//
//  FetchRecentProductQueriesUseCase.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation

// This is another option to create Use Case using more generic way
final class FetchRecentProductQueriesUseCase: UseCase {

    struct RequestValue {
        let maxCount: Int
    }
    typealias ResultValue = (Result<[ProductQuery], Error>)

    private let requestValue: RequestValue
    private let completion: (ResultValue) -> Void
    private let productsQueriesRepository: ProductsQueriesRepository

    init(requestValue: RequestValue,
         completion: @escaping (ResultValue) -> Void,
         productsQueriesRepository: ProductsQueriesRepository) {

        self.requestValue = requestValue
        self.completion = completion
        self.productsQueriesRepository = productsQueriesRepository
    }
    
    func start() -> Cancellable? {

        productsQueriesRepository.fetchRecentsQueries(maxCount: requestValue.maxCount, completion: completion)
        return nil
    }
}

