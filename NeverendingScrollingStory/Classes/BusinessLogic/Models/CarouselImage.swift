//
//  CarouselImage.swift
//  NeverendingScrollingStory
//
//  Created by Robert Gacsi on 09/02/2017.
//  Copyright © 2017 Robert Gacsi. All rights reserved.
//

import Foundation

class CarouselImage {
    
    private(set) var id: String
    
    private(set) var title: String
    
    private(set) var imageURL: URL?
    
    init(id: String, title: String, urlString: String) {
        
        self.id = id
        
        self.title = title
        
        self.imageURL = URL.init(string: urlString)
    }
}

extension CarouselImage: Equatable {

    public static func ==(lhs: CarouselImage, rhs: CarouselImage) -> Bool {
    
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.imageURL == rhs.imageURL
    }
}
