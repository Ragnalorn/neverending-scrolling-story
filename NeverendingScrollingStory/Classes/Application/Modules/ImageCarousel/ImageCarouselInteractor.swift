//
//  ImageCarouselInteractor.swift
//  NeverendingScrollingStory
//
//  Created by Robert Gacsi on 2017. 02. 14..
//  Copyright © 2017. Robert Gacsi. All rights reserved.
//

import Foundation

typealias GetCarouselImagesCompletion = ([CarouselImage]) -> ()

class ImageCarouselInteractor {
    
    fileprivate var getCarouselImagesCompletion: GetCarouselImagesCompletion?

    fileprivate var carouselImagesService: CarouselImagesService? {
        
        get {
            
            return CarouselImagesService(getCarouselImagesDelegate: self)
        }
    }
    
    func getCarouselImages(_ offset: Int, _ limit: Int, completion: @escaping GetCarouselImagesCompletion) {
        
        self.getCarouselImagesCompletion = completion
        
        self.carouselImagesService?.getCarouselImages(offset, limit)
    }
}

extension ImageCarouselInteractor: GetCarouselImagesDelegate {

    func getCarouselImagesFinishedWithResult(_ result: [CarouselImage]) {
        
        DispatchQueue.main.async {
            
            self.getCarouselImagesCompletion?(result)
        }
    }
    
    func getCarouselImagesFinishedWithError(_ error: String?) {
        
        DispatchQueue.main.async {
            
            self.getCarouselImagesCompletion?([])
        }
    }
}
