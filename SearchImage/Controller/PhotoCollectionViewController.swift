//
//  PhotoCollectionViewController.swift
//  SearchImage
//
//  Created by Manjunath on 03/06/22.
//

import UIKit

class PhotoCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var searchBar = UISearchBar()
    var searchStr = ""
    var isLoading = false
    
    private var photos = [PhotoModel]()
    private var pageNumber = 1
    private let segueIdentifier = "gotoPreview"
    private let reuseIdentifier = "PhotoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = searchBar
        searchBar.placeholder = "Search for Anything"
        searchBar.delegate = self
    }
    
    // MARK: - Navigation to PhotoReviewViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let photoViewController = segue.destination as? PhotoReviewViewController else { fatalError() }
        if segue.identifier == segueIdentifier {
            if let indexPaths = collectionView.indexPathsForSelectedItems {
                let indexPath = indexPaths[0]
                photoViewController.photoIndex = indexPath.item
                photoViewController.photos = photos
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension PhotoCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        if photos.count > 0 && indexPath.item < photos.count{
            let photo = photos[indexPath.item]
            cell.imageId = photo.id
            cell.imageView.image = photo.thumbnailImage
            if photo.thumbnailImage == nil {
                DispatchQueue.global(qos: .userInitiated).async {
                    guard let imageData = try? Data(contentsOf: photo.thumbnailURL),
                          let image = UIImage(data: imageData) else { return }
                    photo.thumbnailImage = image
                    if cell.imageId == photo.id {
                        DispatchQueue.main.async {
                            cell.imageView.image = image
                        }
                    }
                }
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= photos.count - 10 && !self.isLoading {
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().asyncAfter(deadline: .now() ) {
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                }
                self.pageNumber += 1
                self.searchPhotos(forString: self.searchStr, page: String(self.pageNumber))
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}
// MARK: - UISearchBarDelegate

extension PhotoCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchString = searchBar.text else { return }
        searchStr = searchString
        resetCollectionView()
        activityIndicator.startAnimating()
        searchPhotos(forString: searchString)
        activityIndicator.stopAnimating()
    }
    
    func resetCollectionView(){
        photos.removeAll()
        collectionView?.reloadData()
    }
    
    func searchPhotos(forString string: String, page: String = "1") {
        pageNumber = page == "1" ? 1 : pageNumber
        PhotoManager.searchImages(from: string, page: page) { [self] result in
            switch (result) {
            case .error(let error):
                print("Error: \(error)")
            case .decodingError:
                print("Decode Error")
            case .unknownResponse:
                print("Unknown Response")
            case .success(let photo):
                photos.append(contentsOf: photo)
                updatePhotos(photos)
                self.isLoading = false
            }
        }
    }
    
    func updatePhotos(_ photos: [PhotoModel]) {
        DispatchQueue.main.async {
            if photos.count > 0 {
                self.photos = photos
                self.collectionView?.reloadData()
            } else {
                self.searchBar.text = ""
                self.searchBar.placeholder = "Type valid name"
                self.photos.removeAll()
                self.collectionView?.reloadData()
            }
        }
    }
}


