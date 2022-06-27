//
//  ProductsListViewModelActions.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//


import Foundation

struct ProductsListViewModelActions {
    
    let showProductDetails: (Product) -> Void
}

enum ProductsListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol ProductsListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSearch(query: String)
    func didCancelSearch()
    func didSelectItem(at index: Int)
}

protocol ProductsListViewModelOutput {
    var items: Observable<[ProductsListItemViewModel]> { get } 
    var loading: Observable<ProductsListViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol ProductsListViewModel: ProductsListViewModelInput, ProductsListViewModelOutput {}

final class DefaultProductsListViewModel: ProductsListViewModel {

    private let searchProductsUseCase: ListProductsUseCase
    private let actions: ProductsListViewModelActions?

    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    private var pages: [ProductsPage] = []
    private var productsLoadTask: Cancellable? { willSet { productsLoadTask?.cancel() } }

    // MARK: - OUTPUT

    let items: Observable<[ProductsListItemViewModel]> = Observable([])
    let loading: Observable<ProductsListViewModelLoading?> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    let screenTitle = NSLocalizedString("Products", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Products", comment: "")

    // MARK: - Init

    init(searchProductsUseCase: ListProductsUseCase,
         actions: ProductsListViewModelActions? = nil) {
        self.searchProductsUseCase = searchProductsUseCase
        self.actions = actions
    }

    // MARK: - Private

    private func appendPage(_ productsPage: ProductsPage) {
        currentPage = 0

        pages = pages
            .filter { $0.products != productsPage.products }
            + [productsPage]

        items.value = pages.products.map(ProductsListItemViewModel.init)
    }

    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        items.value.removeAll()
    }

    private func load(productQuery: ProductQuery, loading: ProductsListViewModelLoading) {
        self.loading.value = loading
        productsLoadTask = searchProductsUseCase.execute(
            requestValue: .init(query: productQuery, page: nextPage),
            cached: appendPage,
            completion: { result in
                switch result {
                case .success(let page):
                    self.appendPage(page)
                case .failure(let error):
                    self.handle(error: error)
                }
                self.loading.value = .none
        })
    }

    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading Products", comment: "")
    }

    private func update(productQuery: ProductQuery) {
        resetPages()
        load(productQuery: productQuery, loading: .fullScreen)
    }
}

// MARK: - INPUT. View event methods

extension DefaultProductsListViewModel {

    func viewDidLoad() { }

    func didLoadNextPage() {
        guard hasMorePages, loading.value == .none else { return }
        load(productQuery: .init(query: query.value),
             loading: .nextPage)
    }

    func didSearch(query: String) {
        UIImageView.init().imageCleanCacheFromServer()
        update(productQuery: ProductQuery(query: query))
    }

    func didCancelSearch() {
        productsLoadTask?.cancel()
    }

    func didSelectItem(at index: Int) {
        actions?.showProductDetails(pages.products[index])
    }
}

// MARK: - Private

private extension Array where Element == ProductsPage {
    var products: [Product] { flatMap { $0.products } }
}
