//
//  ImageCarouselViewController.swift
//  NeverendingScrollingStory
//
//  Created by Robert Gacsi on 09/02/2017.
//  Copyright © 2017 Robert Gacsi. All rights reserved.
//

import UIKit

class ImageCarouselViewController: UIViewController, ImageCarouselView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var eventHandler: ImageCarouselEventHandler?
    
    fileprivate var carouselContent: [CarouselImage] = []
    fileprivate var originalCarouselContent: [CarouselImage] = []
    
    fileprivate var lastContentOffsetX: CGFloat = 0.0
    
    fileprivate var carouselOffset: Int = 1
    
    fileprivate var carouselLimit: Int = 3
    
    fileprivate var isInfinitelyScrollingEnabled = false
    
    fileprivate var previousIndex: Int = 0
    
    fileprivate var isPreviouslyScrolledLeft = false
    
    fileprivate var firstCarouselImageId = ""

    fileprivate var isAllCarouselImageDownloaded = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Image Carousel"
        
        self.setupCollectionView()

        self.eventHandler?.getCarouselImages(self.carouselOffset, self.carouselLimit)
    }

    // MARK: - ImageCarouselView methods

    func updateCarouselImages(_ carouselImages: [CarouselImage]) {

        if self.carouselContent.count == 0 {
            
            self.setupCarouselContent(carouselImages)
            
            if carouselContent.count > 0 {
                
                self.firstCarouselImageId = carouselContent[0].id
            }
            
        } else {
        
            self.setupCarouselContent(carouselImages)

        }
    }
    
    // MARK: - Actions
    
    @IBAction func infinitelyScrollableSwitchValueDidChange(_ sender: UISwitch) {
        
        self.isInfinitelyScrollingEnabled = sender.isOn
        
        self.setupCarouselContent(self.carouselContent)
    }
}

// MARK: - Private methods

private extension ImageCarouselViewController {

    func setupCollectionView() {

        let cellClassName = String(describing: ImageCarouselCollectionViewCell.self)
        
        self.collectionView.register(UINib(nibName: cellClassName, bundle: nil), forCellWithReuseIdentifier: cellClassName)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    func setupCarouselContent(_ carouselContent: [CarouselImage]) {
        
        var newContent = [CarouselImage]()
        
        for carouselImage in carouselContent {
            
            if carouselImage.id == self.firstCarouselImageId {
            
                self.isAllCarouselImageDownloaded = true
                
                break
            }
            
            newContent.append(carouselImage)
        }
        
        self.originalCarouselContent.append(contentsOf: newContent)
        
        if self.isInfinitelyScrollingEnabled {

            newContent.append(carouselContent.last!)
            newContent.insert(carouselContent.first!, at: 0)
            
            self.carouselContent.append(contentsOf: newContent)
            
        } else {
        
            self.carouselContent.removeAll()
            self.carouselContent.append(contentsOf: self.originalCarouselContent)
        }

        self.collectionView.reloadData()
    }
}

// MARK: - Collection View methods

extension ImageCarouselViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.carouselContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCarouselCollectionViewCell.self), for: indexPath)
        
        if let imageCarouselCell = cell as? ImageCarouselCollectionViewCell {
            
            let carouselImage = self.carouselContent[indexPath.row]
            
            imageCarouselCell.configureWithCarouselImage(carouselImage)
                        
            carouselImage.imageURL?.downloadImage({ image, imageURL in
                
                if imageCarouselCell.imageURL == imageURL {
                    
                    imageCarouselCell.imageView.image = image
                }
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row > self.previousIndex {
        
            self.carouselOffset += 1
            
            self.isPreviouslyScrolledLeft = true
        
        } else if indexPath.row < self.previousIndex {
            
            self.carouselOffset -= 1
            
            self.isPreviouslyScrolledLeft = false
        }
        
        self.previousIndex = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if !self.isInfinitelyScrollingEnabled && self.isPreviouslyScrolledLeft && indexPath.row == self.carouselContent.count - 2 && !self.isAllCarouselImageDownloaded {
            
            self.eventHandler?.getCarouselImages(self.carouselOffset + 1, self.carouselLimit)
        }
    }
}

extension ImageCarouselViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let marginOffset: CGFloat = 40.0
        
        let cellSize = CGSize(width: self.collectionView.bounds.size.width - marginOffset, height: self.collectionView.bounds.size.height - marginOffset)
        
        return cellSize
    }
}

extension ImageCarouselViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if !self.isInfinitelyScrollingEnabled {
        
            return
        }
        
        if (self.lastContentOffsetX == 0.0) {
            
            self.lastContentOffsetX = scrollView.contentOffset.x
            
            return
        }
        
        let currentOffsetX = scrollView.contentOffset.x
        let currentOffsetY = scrollView.contentOffset.y

        let pageWidth = scrollView.frame.size.width
        let offset = pageWidth * CGFloat(self.carouselContent.count - 2)
        
        if (currentOffsetX < pageWidth && self.lastContentOffsetX > currentOffsetX) {
            
            self.lastContentOffsetX = currentOffsetX + offset
            
            scrollView.contentOffset = CGPoint(x: self.lastContentOffsetX, y: currentOffsetY)
            
        } else if (currentOffsetX > offset && self.lastContentOffsetX < currentOffsetX) {
            
            self.lastContentOffsetX = currentOffsetX - offset
            
            scrollView.contentOffset = CGPoint(x: self.lastContentOffsetX, y: currentOffsetY)
            
        } else {
            
            self.lastContentOffsetX = currentOffsetX
        }
    }
}
