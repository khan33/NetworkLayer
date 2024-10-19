// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

@available(iOS 15.0.0, *)
public protocol NetworkServiceProvider {
    func execute<T: Decodable>(request: Request) async throws -> T
    func downloadData(request: Request) async throws -> Data
}

@available(iOS 15.0, *)
public class NetworkService {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Public API

    deinit {
        session.invalidateAndCancel()
    }
}

@available(iOS 15.0, *)
extension NetworkService: NetworkServiceProvider {
    public enum NetworkServiceError: Error {
        case invalidResponse
        case unacceptableStatusCode(Int)
    }

    public func execute<T: Decodable>(request: Request) async throws -> T {
        let (data, response) = try await session.data(for: request.urlRequest())
        return try request.decoder.decode(T.self, from: data)
    }

    public func downloadData(request: Request) async throws -> Data {
        return try await performRequest(request: request)
    }

    private func performRequest(request: Request) async throws -> Data {
        let (data, response) = try await session.data(for: request.urlRequest())
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkServiceError.invalidResponse
        }

        // Validate status code
        guard 200 ... 299 ~= httpResponse.statusCode else {
            throw NetworkServiceError.unacceptableStatusCode(httpResponse.statusCode)
        }
        return data  // Return the raw data
    }
}
