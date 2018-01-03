//
//  URLExtension.swift
//  NeverendingScrollingStory
//
//  Created by Robert Gacsi on 10/02/2017.
//  Copyright © 2017 Robert Gacsi. All rights reserved.
//

import Foundation
import UIKit

extension URL {

    typealias ImageDownloadCompletion = (UIImage, URL?) -> ()
    
    func downloadImage(_ completion: @escaping ImageDownloadCompletion) {

        let task = URLSession.shared.dataTask(with: self, completionHandler: { data, response, error in
            
            if let  data = data, let image = UIImage(data: data), error == nil {

                DispatchQueue.main.async {
                    
                    completion(image, self)
                }
            }
        })
        
        task.resume()
    }
}
