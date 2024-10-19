//
//  File.swift
//  
//
//  Created by Atta khan on 19/10/2024.
//

import Foundation

public struct Request {
    public enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }

    public let scheme: String
    public let baseURL: String
    public let path: String
    public let method: HttpMethod
    public let queryItems: [URLQueryItem]
    public let decoder: JSONDecoder

    public init(
        scheme: String = "https",
        baseURL: String,
        path: String,
        method: HttpMethod = .get,
        queryItems: [URLQueryItem] = [],
        decoder: JSONDecoder = .init()
    ) {
        self.scheme = scheme
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.decoder = decoder
    }

    public func urlRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseURL
        components.path = path
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        return URLRequest(url: url)
    }
}
