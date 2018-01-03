//
//  CarouselImagesService.swift
//  NeverendingScrollingStory
//
//  Created by Robert Gacsi on 2017. 02. 14..
//  Copyright © 2017. Robert Gacsi. All rights reserved.
//

import Foundation

protocol GetCarouselImagesDelegate: class {
    
    func getCarouselImagesFinishedWithResult(_ result: [CarouselImage])
    
    func getCarouselImagesFinishedWithError(_ error: String?)
}

class CarouselImagesService {
    
    weak var getCarouselImagesDelegate: GetCarouselImagesDelegate?
    
    init(getCarouselImagesDelegate: GetCarouselImagesDelegate) {
        
        self.getCarouselImagesDelegate = getCarouselImagesDelegate
    }
    
    func getCarouselImages(_ offset: Int, _ limit: Int) {

        guard let requestURL = URLProvider.getCarouselImagesURL(offset, limit) else {
        
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> () in
            
            if let _ = error {
                
                self.getCarouselImagesDelegate?.getCarouselImagesFinishedWithError(error?.localizedDescription)
                
            } else {
                
                guard let data = data else {
                    
                    self.getCarouselImagesDelegate?.getCarouselImagesFinishedWithError("Something went wrong with the data!")
                    
                    return
                }
                
                do {
                    
                    let resultData = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as AnyObject
                    
                    let processedResult = self.processResultData(resultData)
                    
                    self.getCarouselImagesDelegate?.getCarouselImagesFinishedWithResult(processedResult)
                    
                } catch _ as NSError {
                    
                    self.getCarouselImagesDelegate?.getCarouselImagesFinishedWithError("Something went wrong!")
                }
            }
        }
        
        task.resume()
    }
}

private extension CarouselImagesService {

    func processResultData(_ resultData: AnyObject) -> [CarouselImage] {
        
        var result: [CarouselImage] = []
        
        for carouselImageArray in resultData as! [AnyObject] {
        
            var carouselImageId = ""
            var carouselImageTitle = ""
            var carouselImageURLString = ""
            
            if let imageId = carouselImageArray["id"] as? String {
            
                carouselImageId = imageId
            }
            
            if let imageTitle = carouselImageArray["title"] as? String {
                
                carouselImageTitle = imageTitle
            }

            if let imageURLString = carouselImageArray["images"] as? String {
                
                carouselImageURLString = imageURLString
            }
            
            let carouselImage = CarouselImage(id: carouselImageId, title: carouselImageTitle, urlString: carouselImageURLString)
            
            result.append(carouselImage)
        }

        return result
    }
}
