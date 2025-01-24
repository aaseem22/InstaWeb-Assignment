//
//  NetworkError.swift
//  InstaWeb-Assignment
//
//  Created by Aaseem Mhaskar on 21/01/25.
//

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case invalidResponse
    case serverError(String)
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Error decoding data"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let message):
            return message
        }
    }
}
