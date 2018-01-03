//
//  ImageCarouselWireframe.swift
//  NeverendingScrollingStory
//
//  Created by Robert Gacsi on 08/02/2017.
//  Copyright © 2017 Robert Gacsi. All rights reserved.
//

import UIKit

class ImageCarouselWireframe {
    
    fileprivate var presenter: ImageCarouselPresenter?
    
    fileprivate var view = ImageCarouselViewController()

    init() {
        
        self.presenter = ImageCarouselPresenter(view: self.view)
        
        self.view.eventHandler = self.presenter
    }
}

// MARK: - Wireframe protocol methods

extension ImageCarouselWireframe: Wireframe {
    
    func viewController() -> UIViewController {
        
        return self.view
    }
}
