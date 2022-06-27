//
//  String+Extension.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import Foundation

extension String {
    
    func getIdUrl()-> String{
        let idProduct = self.components(separatedBy: "/")
        return  idProduct[6]
    }
    
}
