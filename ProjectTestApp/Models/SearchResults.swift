//
//  SearchResults.swift
//  ProjectTestApp
//
//  Created by Никита Горбунов on 20.10.2022.
//

import Foundation

struct SearchResults: Decodable {
    var photos: Photos
    let stat: String
}

struct Photos: Decodable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    var photo: [Photo]
}

struct Photo: Decodable {
    let title: String
    let date: String
    let tags: String?
    let url: String?
    let height: Int
    let width: Int
    
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case date = "datetaken"
        case tags = "tags"
        case url = "url_z"
        case height = "height_z"
        case width = "width_z"
    }
}
