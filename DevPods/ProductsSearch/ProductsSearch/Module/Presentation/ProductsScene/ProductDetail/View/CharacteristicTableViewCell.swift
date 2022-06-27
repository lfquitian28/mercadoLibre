//
//  CharacteristicTableViewCell.swift
//  ProductsSearch
//
//  Created by Luis Francisco Quitian Cabra on 25/06/22.
//

import UIKit

class CharacteristicTableViewCell: UITableViewCell {

    @IBOutlet weak var valueCharacteristic: UILabel!
    @IBOutlet weak var nameCharacteristic: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(characteristic: ListAttributes) {
        let name = characteristic.name
        nameCharacteristic.text = name
        let valueName = characteristic.value_name
        valueCharacteristic.text = valueName
        
    }
    
}
