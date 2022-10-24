//
//  NetworkManager.swift
//  ProjectTestApp
//
//  Created by Никита Горбунов on 20.10.2022.
//

import Foundation


class NetworkManager {

    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {

        let parameters = self.prepareParameters(searchTerm: searchTerm)
        let url = self.url(params: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()

    }


    private func prepareParameters(searchTerm: String?) -> [String: String] {
        var parameters = [
            "method" : "flickr.interestingness.getList",
            "api_key" : "c6a1ba4cc135d86c115cc43bc9b3ac9f",
            "sort" : "relevance",
            "per_page" : "30",
            "format" : "json",
            "nojsoncallback" : "1",
            "extras" : "url_z, date_taken, url_l, tags"
            ]
        if let searchTerm = searchTerm {
            parameters["method"] = "flickr.photos.search"
            parameters["text"] = searchTerm
        }
        return parameters
    }

    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest/"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }

    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
