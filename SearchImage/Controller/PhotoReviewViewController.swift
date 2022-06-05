//
//  PhotoReviewViewController.swift
//  SearchImage
//
//  Created by Manjunath on 03/06/22.
//


import UIKit
import Photos

class PhotoReviewViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var resolutionLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var photos: [PhotoModel]?
    var photoIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIView()
    }
    
    private func updateUIView() {
        guard let photoIndex = photoIndex,
              let photo = photos?[photoIndex] else { return }
        updateImageView(from: photo)
        updateImageDetails(from: photo)
    }
    
    private func updateImageView(from photo: PhotoModel) {
        if photo.largeImage != nil {
            imageView.image = photo.largeImage
            return
        }
        activityIndicator.startAnimating()
        DispatchQueue.main.async {
            guard let imageData = try? Data(contentsOf: photo.largeImageURL),
                  let image = UIImage(data: imageData) else { return }
            self.activityIndicator.stopAnimating()
            photo.largeImage = image
            self.imageView.image = photo.largeImage
        }
    }
    
    private func updateImageDetails(from photo: PhotoModel) {
        self.userLabel.text = "User:  \(photo.user)"
        self.resolutionLabel.text = "Resolution:  \(photo.imageWidth) X \(photo.imageHeight)"
        self.tagsLabel.text = "Tags:   \(photo.tags)"
    }
}
