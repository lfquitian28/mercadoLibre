//
//  ProductTableViewCell.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionProduct: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var titleProduct: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func bind(product: ProductsListItemViewModel) {
        let url = product.thumbnail!
        imageProduct.imageFromServerURLCache(urlString: "\(url)", placeHolderImage: UIImage(named:"preload", in: Bundle(for: Self.self), compatibleWith: nil)!)
        titleProduct?.text = product.title!
        if let price = product.price{
            self.descriptionProduct?.text = "$ \(String(describing: price) )"
        }
        
    }
    
}
