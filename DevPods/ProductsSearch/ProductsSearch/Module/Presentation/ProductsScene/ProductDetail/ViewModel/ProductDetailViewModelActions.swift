//
//  ProductDetailViewModel.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation

protocol ProductDetailViewModelInput {
    func updateProductDetail(productId: String)
}

protocol ProductDetailViewModelOutput {
    var items: Observable<[ProductsDetailItemViewModel]> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var product: Product { get }
    var isEmpty: Bool { get }
    var errorTitle: String { get }
    var posterImage: Observable<Data?> { get }
}

protocol ProductDetailViewModel: ProductDetailViewModelInput, ProductDetailViewModelOutput { }

final class DefaultProductDetailViewModel: ProductDetailViewModel {
    
    let product: Product
    private let searchProductDetailUseCase: ProductDetailUseCase
    private var productDetailLoadTask: Cancellable? { willSet { productDetailLoadTask?.cancel() } }
    
    // MARK: - OUTPUT
    let items: Observable<[ProductsDetailItemViewModel]> = Observable([])
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    let posterImage: Observable<Data?> = Observable(nil)
    let errorTitle = NSLocalizedString("Error", comment: "")
    var isEmpty: Bool = false
    
    // MARK: - Init

    init(searchProductDetailUseCase: ProductDetailUseCase,
         product: Product) {
        self.searchProductDetailUseCase = searchProductDetailUseCase
        self.product = product
        self.updateProductDetail(productId: self.product.id!)
    }
    
    // MARK: - Private

    private func productDetail(_ productDetail: ProductDetailBody) {
        items.value  += [ProductsDetailItemViewModel.init(product: productDetail.body)]
        isEmpty = true
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading Products", comment: "")
    }

    
    private func load(productDetailQuery: ProductDetailQuery, loading: ProductsListViewModelLoading) {
        productDetailLoadTask = searchProductDetailUseCase.execute(
            requestValue: .init(ids: productDetailQuery),
            cached: productDetail,
            completion: { result in
                switch result {
                case .success(let detail):
                    self.productDetail(detail)
                case .failure(let error):
                    self.handle(error: error)
                }
        })
    }
    
    private func searchDetail(productDetailQuery: ProductDetailQuery) {
        load(productDetailQuery: productDetailQuery, loading: .fullScreen)
    }
}

// MARK: - INPUT. View event methods
extension DefaultProductDetailViewModel {
    
    func viewDidLoad() { }
    
    func updateProductDetail(productId: String) {
        let productDetailQuery = ProductDetailQuery(ids: productId)
        searchDetail(productDetailQuery: productDetailQuery)
    }
}


// MARK: - Private
private extension Array where Element == ProductDetail {
    var pictures: [ListPictures] { flatMap { $0.pictures } }
}

private extension Array where Element == ProductDetail {
    var attributes: [ListAttributes] { flatMap { $0.attributes } }
}
