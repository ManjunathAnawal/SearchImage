//
//  PhotoManager.swift
//  SearchImage
//
//  Created by Manjunath on 03/06/22.
//

import UIKit

enum PhotoSearchResponse {
    case success([PhotoModel])
    case error(Error)
    case unknownResponse
    case decodingError
}

class PhotoManager {
    private static let baseURL = "https://pixabay.com/api/"
    private static let apiKey = "27810710-bd1366ad5d37f1032c956d821"
    
    static func searchImages(from searchQuery: String,page: String, completionHandler: @escaping (PhotoSearchResponse) -> Void) {
        let requestURL = getURL(from: searchQuery, page: page)
        let task = URLSession.shared.dataTask(with: requestURL.url!) { data, response, error in
            if let error = error {
                completionHandler(.error(error))
                return
            }
            guard response != nil else {
                completionHandler(.unknownResponse)
                return
            }
            guard let data = data,
                  let hits = try? JSONDecoder().decode(PhotoData.self, from: data).hits else {
                completionHandler(.decodingError)
                return
            }
            let photos = hits.compactMap() { hit in
                return PhotoModel(id: hit.id, thumbnailURL: hit.previewURL, largeImageURL: hit.largeImageURL,imageWidth: hit.imageWidth, imageHeight: hit.imageHeight, user: hit.user, tags: hit.tags )
            }
            completionHandler(.success(photos))
        }
        task.resume()
    }
    
    private static func getURL(from searchQuery: String, page: String) -> URLComponents {
        var requestURL = URLComponents(string: baseURL)!
        requestURL.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)),
            URLQueryItem(name: "safesearch", value: "true"),
            URLQueryItem(name: "per_page", value: "200"),
            URLQueryItem(name: "page", value: page)
        ]
        return requestURL
    }
}


