//
//  ProductsListViewModelMock.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 26/06/22.
//

import Foundation
import FBSnapshotTestCase
@testable import ProductsSearch

class ProductsListViewTests: FBSnapshotTestCase {

    let products: [Product] = [
            Product.stub(id: "1", title: "title1", price: 0, thumbnail: "/1"),
            Product.stub(id: "2", title: "title2", price: 0, thumbnail: "/2"),
            Product.stub(id: "3", title: "title3", price: 0, thumbnail: "/3")
    ]

    override func setUp() {
        super.setUp()
        //self.recordMode = true
    }

    func test_whenViewIsEmpty_thenShowEmptyScreen() {
        // given
        let vc = ProductsListViewController.create(
            with: ProductsListViewModelMock.stub(isEmpty: true,
                                               emptyDataTitle: NSLocalizedString("", comment: "Search results"),
                                               searchBarPlaceholder: NSLocalizedString("Search Products", comment: "")
            ))

        // then
        FBSnapshotVerifyView(vc.view)
    }

    func test_whenHasItems_thenShowItemsOnScreen() {
        // given
        let items = products.map(ProductsListItemViewModel.init)
        let vc = ProductsListViewController.create(
            with: ProductsListViewModelMock.stub(items: Observable(items),
                                               isEmpty: false,
                                               emptyDataTitle: NSLocalizedString("Search results", comment: ""),
                                               searchBarPlaceholder: NSLocalizedString("Search Products", comment: "")
            ))

        // then
        FBSnapshotVerifyView(vc.view)
    }
}


struct ProductsListViewModelMock: ProductsListViewModel {
    // MARK: - Input
    func viewDidLoad() {}
    func didLoadNextPage() {}
    func didSearch(query: String) {}
    func didCancelSearch() {}
    func showQueriesSuggestions() {}
    func closeQueriesSuggestions() {}
    func didSelectItem(at index: Int) {}

    // MARK: - Output
    var items: Observable<[ProductsListItemViewModel]>
    var loading: Observable<ProductsListViewModelLoading?>
    var query: Observable<String>
    var error: Observable<String>
    var isEmpty: Bool
    var screenTitle: String
    var emptyDataTitle: String
    var errorTitle: String
    var searchBarPlaceholder: String

    static func stub(items: Observable<[ProductsListItemViewModel]> = Observable([]),
                     loading: Observable<ProductsListViewModelLoading?> = Observable(nil),
                     query: Observable<String> = Observable(""),
                     error: Observable<String> = Observable(""),
                     isEmpty: Bool = true,
                     screenTitle: String = NSLocalizedString("Products", comment: ""),
                     emptyDataTitle: String = NSLocalizedString("Search results", comment: ""),
                     errorTitle: String = NSLocalizedString("Error", comment: ""),
                     searchBarPlaceholder: String = NSLocalizedString("Search Products", comment: "")) -> Self {
        .init(items: items,
              loading: loading,
              query: query,
              error: error,
              isEmpty: isEmpty,
              screenTitle: screenTitle,
              emptyDataTitle: emptyDataTitle,
              errorTitle: errorTitle,
              searchBarPlaceholder: searchBarPlaceholder)
    }
}
