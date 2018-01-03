//
//  ImageCarouselCollectionViewCell.swift
//  NeverendingScrollingStory
//
//  Created by Robert Gacsi on 09/02/2017.
//  Copyright © 2017 Robert Gacsi. All rights reserved.
//

import UIKit

class ImageCarouselCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var imageURL: URL?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    func configureWithCarouselImage(_ carouselImage: CarouselImage) {
    
        self.titleLabel.text = carouselImage.title
        
        self.imageURL = carouselImage.imageURL
    }    
}
