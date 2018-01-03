//
//  ImageCarouselEventHandler.swift
//  NeverendingScrollingStory
//
//  Created by Robert Gacsi on 09/02/2017.
//  Copyright © 2017 Robert Gacsi. All rights reserved.
//

import Foundation

protocol ImageCarouselEventHandler {
    
    func getCarouselImages(_ offset: Int, _ limit: Int)    
}
