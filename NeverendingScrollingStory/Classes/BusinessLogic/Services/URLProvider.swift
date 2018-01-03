//
//  URLProvider.swift
//  NeverendingScrollingStory
//
//  Created by Robert Gacsi on 2017. 02. 14..
//  Copyright © 2017. Robert Gacsi. All rights reserved.
//

import Foundation

class URLProvider {
    
    fileprivate static let baseURL = "https://image-carousel-4ever.herokuapp.com/"
    
    fileprivate static let getCarouselImagesEndPoint = "carouselImages.php?offset=OFFSET&limit=LIMIT"

    static func getCarouselImagesURL(_ offset: Int, _ limit: Int) -> URL? {
        
        var urlString = self.baseURL + self.getCarouselImagesEndPoint
        urlString = urlString.replacingOccurrences(of: "OFFSET", with: "\(offset)")
        urlString = urlString.replacingOccurrences(of: "LIMIT", with: "\(limit)")
        
        return URL(string: urlString)
    }
}
