//
//  NetworkService.swift
//  ANF Code Test
//
//  Created by Irfan Mohammed on 10/24/25.
//

import UIKit

enum ExploreCardError: Error, LocalizedError {
    case invalidURL
    case invalidStatusCode
    case invalidCode
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidStatusCode:
            return "Invalid status code"
        case .invalidCode:
            return "Failed to decode JSON"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

protocol NetworkServiceProtocol {
    func fetchExploreData() async throws -> [ExploreCard]
    func loadImage(from urlString: String) async -> UIImage?
}

class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Properties
    
    private let exploreDataURL = "https://www.abercrombie.com/anf/nativeapp/qa/codetest/codeTest_exploreData.css"
    private let imageCache = NSCache<NSString, UIImage>()
    
    private func request<T: Decodable>(urlString: String) async throws -> T {
        // URL
        guard let url = URL(string: urlString) else {
            throw ExploreCardError.invalidURL
        }
        
        // UrlSession call
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Status code
            guard let responseStatus = response as? HTTPURLResponse, responseStatus.statusCode == 200 else {
                throw ExploreCardError.invalidStatusCode
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw ExploreCardError.invalidCode
            }
        } catch let error as ExploreCardError {
            throw error
        } catch {
            throw ExploreCardError.networkError(error)
        }
    }
    
    func fetchExploreData() async throws -> [ExploreCard] {
        return try await request(urlString: exploreDataURL)
    }
    
    func loadImage(from urlString: String) async -> UIImage? {
        // Check cache first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            print("✅ Image loaded from cache: \(urlString)")
            return cachedImage
        }
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            return nil
        }
        
        print("🔄 Loading image from: \(urlString)")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else {
                print("❌ Failed to create image from data")
                return nil
            }
            
            print("✅ Image loaded successfully: \(urlString)")
            
            // Cache the image
            imageCache.setObject(image, forKey: urlString as NSString)
            
            return image
        } catch {
            print("❌ Error loading image: \(error.localizedDescription)")
            return nil
        }
    }
}
