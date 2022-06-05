//
//  PhotoModel.swift
//  SearchImage
//
//  Created by Manjunath on 03/06/22.
//

import UIKit

class PhotoModel {
    let id: Int
    let thumbnailURL: URL
    let largeImageURL: URL
    var thumbnailImage: UIImage?
    var largeImage: UIImage?
    let tags: String
    let imageWidth: Int
    let imageHeight: Int
    let user: String
    
    init(id: Int, thumbnailURL: URL, largeImageURL: URL, imageWidth: Int, imageHeight: Int, user: String, tags: String ) {
        self.id = id
        self.thumbnailURL = thumbnailURL
        self.largeImageURL = largeImageURL
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.user = user
        self.tags = tags
    }
}

