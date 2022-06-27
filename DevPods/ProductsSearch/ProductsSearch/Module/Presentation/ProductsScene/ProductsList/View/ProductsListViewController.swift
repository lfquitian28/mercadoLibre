//
//  ProductsListViewController.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import UIKit

class ProductsListViewController: UIViewController,Alertable {
    
    private var viewModel: ProductsListViewModel!

    private var searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var productsTableView: UITableView!
    
    @IBOutlet weak var emptyDataLabel: UILabel!
    @IBOutlet private var productsListContainer: UIView!
    @IBOutlet private var searchBarContainer: UIView!
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: ProductsListViewModel) -> ProductsListViewController {
        let view = ProductsListViewController(nibName: "ProductsListViewController", bundle: Bundle(for: Self.self))
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupSearchController()
        bind(to: viewModel)
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func bind(to viewModel: ProductsListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0) }
        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchQuery($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    
    private func configureTableView(){

        productsTableView.rowHeight = UITableViewAutomaticDimension
        productsTableView.register(UINib(nibName: "ProductTableViewCell", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: "ProductTableViewCell")
    }

    // MARK: - Response Observable Private

    private func setupViews() {
        title = viewModel.screenTitle
        
    }

    private func setupBehaviours() {
        
    }

    private func updateItems() {
        productsTableView.reloadData()
        
        LoadingView.hide()
    }

    private func updateLoading(_ loading: ProductsListViewModelLoading?) {
        productsListContainer.isHidden = true
        LoadingView.hide()
        switch loading {
        case .fullScreen: LoadingView.show()
        case .nextPage: productsListContainer.isHidden = false
        case .none:
            productsListContainer.isHidden = !viewModel.isEmpty
        }

        updateQueriesSuggestions()
    }
    

    private func updateQueriesSuggestions() {
        guard searchController.searchBar.isFirstResponder else {
           
            return
        }
    }

    private func updateSearchQuery(_ query: String) {
        searchController.isActive = false
        searchController.searchBar.text = query
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }

}

// MARK: - Table View Controller

extension ProductsListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as! ProductTableViewCell
        
        cell.bind(product: viewModel.items.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
    
    
    

}

// MARK: - Search Controller

extension ProductsListViewController {
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.barStyle = .black
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true

    }
}

extension ProductsListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = true
        viewModel.didSearch(query: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}

extension ProductsListViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }

    public func willDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }
}
