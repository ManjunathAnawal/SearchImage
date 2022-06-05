//
//  PhotoData.swift
//  SearchImage
//
//  Created by Manjunath on 03/06/22.
//

import UIKit

struct PhotoData: Codable {
    struct Hit: Codable {
        let id: Int
        let largeImageURL: URL
        let previewURL: URL
        let imageWidth: Int
        let imageHeight: Int
        let user: String
        let tags: String
    }
    let hits: [Hit]
}
