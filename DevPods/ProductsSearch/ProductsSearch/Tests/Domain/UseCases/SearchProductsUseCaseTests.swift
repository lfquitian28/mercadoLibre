//
//  SearchProductsUseCaseTests.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 26/06/22.
//

import XCTest
@testable import ProductsSearch

class SearchProductsUseCaseTests: XCTestCase {

    static let productsPages: [ProductsPage] = {
        let page1 = ProductsPage(products: [
            Product.stub(id: "1", title: "title1", price: 0, thumbnail: "/1"),
            Product.stub(id: "2", title: "title2", price: 0, thumbnail: "/2")], page: 1)
        let page2 = ProductsPage(products: [
            Product.stub(id: "3", title: "title3", price: 0, thumbnail: "/3"),
        ], page: 2)
        return [page1, page2]
    }()

    enum ProductsRepositorySuccessTestError: Error {
        case failedFetching
    }

    class ProductsQueriesRepositoryMock: ProductsQueriesRepository {
        var recentQueries: [ProductQuery] = []

        func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ProductQuery], Error>) -> Void) {
            completion(.success(recentQueries))
        }
        func saveRecentQuery(query: ProductQuery, completion: @escaping (Result<ProductQuery, Error>) -> Void) {
            recentQueries.append(query)
        }
    }

    struct ProductsRepositoryMock: ProductsRepository {
        
        var result: Result<ProductsPage, Error>
        func fetchProductsList(query: ProductQuery, cached: @escaping (ProductsPage) -> Void, completion: @escaping (Result<ProductsPage, Error>) -> Void) -> Cancellable? {
            completion(result)
            return nil
        }
    }

    func testSearchProductsUseCase_whenSuccessfullyFetchesProductsForQuery_thenQueryIsSavedInRecentQueries() {
        // given
        let expectation = self.expectation(description: "Recent query saved")
        expectation.expectedFulfillmentCount = 2
        let productsQueriesRepository = ProductsQueriesRepositoryMock()
        let useCase = DefaultSearchProductsUseCase(productsRepository: ProductsRepositoryMock(result: .success(SearchProductsUseCaseTests.productsPages[0])),
                                                 productsQueriesRepository: productsQueriesRepository)

        // when
        let requestValue = SearchProductsUseCaseRequestValue(query: ProductQuery(query: "title1"),
                                                           page: 0)
        _ = useCase.execute(requestValue: requestValue, cached: { _ in }) { _ in
            expectation.fulfill()
        }
        // then
        var recents = [ProductQuery]()
        productsQueriesRepository.fetchRecentsQueries(maxCount: 1) { result in
            recents = (try? result.get()) ?? []
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(recents.contains(ProductQuery(query: "title1")))
    }

    func testSearchProductsUseCase_whenFailedFetchingProductsForQuery_thenQueryIsNotSavedInRecentQueries() {
        // given
        let expectation = self.expectation(description: "Recent query should not be saved")
        expectation.expectedFulfillmentCount = 2
        let productsQueriesRepository = ProductsQueriesRepositoryMock()
        let useCase = DefaultSearchProductsUseCase(productsRepository: ProductsRepositoryMock(result: .failure(ProductsRepositorySuccessTestError.failedFetching)),
                                                 productsQueriesRepository: productsQueriesRepository)

        // when
        let requestValue = SearchProductsUseCaseRequestValue(query: ProductQuery(query: "title1"),
                                                           page: 0)
        _ = useCase.execute(requestValue: requestValue, cached: { _ in }) { _ in
            expectation.fulfill()
        }
        // then
        var recents = [ProductQuery]()
        productsQueriesRepository.fetchRecentsQueries(maxCount: 1) { result in
            recents = (try? result.get()) ?? []
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(recents.isEmpty)
    }
}
