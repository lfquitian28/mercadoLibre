//
//  ProductDetailViewController.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//
// swiftlint:disable all
import UIKit

class ProductDetailViewController:  UIViewController,Alertable{
    
    // MARK: - Lifecycle
    
    @IBOutlet weak var titleProduc: UILabel!
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var tableCharacteristic: UITableView!
    @IBOutlet weak var iCarouselView: iCarousel!
    
    private var viewModel: ProductDetailViewModel!
    
    static func create(with viewModel: ProductDetailViewModel) -> ProductDetailViewController {
        let view = ProductDetailViewController(nibName: "ProductDetailViewController", bundle: Bundle(for: Self.self))
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        iCarouselView.type = .rotary
        iCarouselView.contentMode = .scaleAspectFill
        iCarouselView.isPagingEnabled = true
        bind(to: viewModel)
        configureTableView()
        // Do any additional setup after loading the view.
    }

    private func bind(to viewModel: ProductDetailViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchQuery($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    private func configureTableView() {
        tableCharacteristic.rowHeight = UITableViewAutomaticDimension
        tableCharacteristic.register(UINib(nibName: "CharacteristicTableViewCell", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: "CharacteristicTableViewCell")
    }


    
    // MARK: - Response Observable Private

    private func setupViews() {
        
        
    }

    private func setupBehaviours() {
        
    }

    private func updateItems() {
        if viewModel.isEmpty {
            titleProduc.text = viewModel.items.value[0].title
            if let price = viewModel.items.value[0].price{
                self.price.text = String(describing: price)
            }
            iCarouselView.reloadData()
        }
        
        tableCharacteristic.reloadData()
    }

    private func updateLoading(_ loading: ProductsListViewModelLoading?) {
        
    }

    private func updateSearchQuery(_ query: String) {
        
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ProductDetailViewController: iCarouselDataSource,iCarouselDelegate{
    func numberOfItems(in carousel: iCarousel) -> Int {
        if viewModel.isEmpty {
            return viewModel.items.value[0].pictures.count
        }
        return 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var imageView: UIImageView!
        if view == nil {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 300))
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView = view as? UIImageView
        }
        if viewModel.isEmpty {
            imageView.imageFromServerURL(urlString: viewModel.items.value[0].pictures[index].url ?? "", placeHolderImage: UIImage(named:"preload", in: Bundle(for: Self.self), compatibleWith: nil)!)
        }
        return imageView
    }
}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isEmpty {
            return viewModel.items.value[0].pictures.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacteristicTableViewCell") as! CharacteristicTableViewCell
        if (viewModel.isEmpty) && (if indexPath.row < viewModel.items.value[0].attributes.count) {
                cell.bind(characteristic: viewModel.items.value[0].attributes[indexPath.row])
        }
        return cell
    }
    
    

    

}
