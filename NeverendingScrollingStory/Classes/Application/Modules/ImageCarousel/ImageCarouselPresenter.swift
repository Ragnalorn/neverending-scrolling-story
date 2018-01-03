//
//  ImageCarouselPresenter.swift
//  NeverendingScrollingStory
//
//  Created by Robert Gacsi on 09/02/2017.
//  Copyright © 2017 Robert Gacsi. All rights reserved.
//

import Foundation

class ImageCarouselPresenter {
    
    fileprivate weak var view: ImageCarouselView?
    
    fileprivate let interactor = ImageCarouselInteractor()
    
    fileprivate var isGetCarouselImagesInProgress = false

    init(view: ImageCarouselView?) {
        
        self.view = view
    }
}

extension ImageCarouselPresenter: ImageCarouselEventHandler {
    
    func getCarouselImages(_ offset: Int, _ limit: Int) {
    
        if self.isGetCarouselImagesInProgress {
        
            return
        }
        
        self.isGetCarouselImagesInProgress = true
        
        self.interactor.getCarouselImages(offset, limit) { [unowned self] (carouselImages) in
            
            self.view?.updateCarouselImages(carouselImages)
            
            self.isGetCarouselImagesInProgress = false
        }
    }    
}
