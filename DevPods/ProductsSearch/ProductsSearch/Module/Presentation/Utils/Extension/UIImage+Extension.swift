//
//  UIImage+Extension.swift
//  ProductUIKIT
//
//  Created by Luis Francisco Quitian Cabra on 21/06/22.
//

import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    
    
    
    func imageFromServerURL(urlString:String, placeHolderImage: UIImage){
        
        if self.image == nil{
            self.image = placeHolderImage
        }
        
        //llamado de la url de la imagen
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            
            if error != nil{
                return
            }
            
            DispatchQueue.main.async {
                guard let data = data else {return}
                let image = UIImage(data: data)
                self.image = image
            }
        }.resume()
        
    }
    func imageCleanCacheFromServer(){
        imageCache.removeAllObjects()
    }
    
    func imageFromServerURLCache(urlString:String, placeHolderImage: UIImage){
        if self.image == nil{
            self.image = placeHolderImage
        }
        
        if self.image == imageCache.object(forKey: urlString as NSString) as? UIImage{
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString)else{
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self?.image = image
                    }
                }
            }
            
        }
    }

}

