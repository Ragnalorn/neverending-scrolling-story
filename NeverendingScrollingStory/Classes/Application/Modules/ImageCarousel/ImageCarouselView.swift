//
//  ImageCarouselView.swift
//  NeverendingScrollingStory
//
//  Created by Robert Gacsi on 09/02/2017.
//  Copyright © 2017 Robert Gacsi. All rights reserved.
//

import Foundation

protocol ImageCarouselView: class {
    
    var eventHandler: ImageCarouselEventHandler? {get set}
    
    func updateCarouselImages(_ carouselImages: [CarouselImage])
}
