//
//  Courier.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/15/24.
//

import Foundation

struct CourierError: Error {
    let code: Int
    let message: String
    let data: (Data, URLResponse)?
    
    init(_ code: Int, _ message: String, _ data: (Data, URLResponse)?) {
        self.code = code
        self.message = message
        self.data = data
    }
}

extension CourierError: LocalizedError {
    var errorDescription: String? { return message }
}

class Courier {
    func get<T: Codable>(
        url: URL,
        headers: [String: String] = [:],
        queries: [URLQueryItem] = []
    ) async -> Result<T, CourierError> {
        var request = URLRequest(url: url.appending(queryItems: queries))
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            
            guard let httpResponse = response as? HTTPURLResponse
            else {
                return .failure(CourierError(-1, "Failed to get HTTP response.", (data, response)))
            }
            
            guard (200..<300).contains(httpResponse.statusCode)
            else {
                return .failure(CourierError(httpResponse.statusCode, "Request was not ok.", (data, response)))
            }
            
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch let e {
            return .failure(CourierError(-1, e.localizedDescription, nil))
        }
    }
    
    func post<T: Codable>(
        url: URL,
        headers: [String: String],
        body: Codable
    ) async -> Result<T, CourierError> {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        do {
            let encoder = JSONEncoder()
            let payload = try encoder.encode(body)
            request.httpBody = payload
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            
            guard let httpResponse = response as? HTTPURLResponse
            else {
                return .failure(CourierError(-1, "Failed to get HTTP response.", (data, response)))
            }
            
            guard (200..<300).contains(httpResponse.statusCode)
            else {
                return .failure(CourierError(httpResponse.statusCode, "Request was not ok.", (data, response)))
            }
            
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch let e {
            return .failure(CourierError(-1, e.localizedDescription, nil))
        }
    }
    
    func patch<T: Codable>(
        url: URL,
        headers: [String: String],
        body: Codable
    ) async -> Result<T, CourierError> {
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        do {
            let encoder = JSONEncoder()
            let payload = try encoder.encode(body)
            request.httpBody = payload
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            
            guard let httpResponse = response as? HTTPURLResponse
            else {
                return .failure(CourierError(-1, "Failed to get HTTP response.", (data, response)))
            }
            
            guard (200..<300).contains(httpResponse.statusCode)
            else {
                return .failure(CourierError(httpResponse.statusCode, "Request was not ok.", (data, response)))
            }
            
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch let e {
            return .failure(CourierError(-1, e.localizedDescription, nil))
        }
    }
    
    func delete(
        url: URL,
        headers: [String: String]
    ) async -> Result<(), CourierError> {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse
            else {
                return .failure(CourierError(-1, "Failed to get HTTP response.", (data, response)))
            }
            
            guard (200..<300).contains(httpResponse.statusCode)
            else {
                return .failure(CourierError(httpResponse.statusCode, "Request was not ok.", (data, response)))
            }
            
            return .success(())
        } catch let e {
            return .failure(CourierError(-1, e.localizedDescription, nil))
        }
    }
}
