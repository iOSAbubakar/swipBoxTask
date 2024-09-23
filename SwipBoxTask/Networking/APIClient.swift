//
//  APIClient.swift
//  SwipBoxTask
//
//  Created by Smart-IS on 21/09/2024.
//

import Foundation

// Define a protocol to make the API Client testable
protocol APIClientProtocol {
    func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void)
}

class APIClient: APIClientProtocol {
    
    let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyOGFkNDU1ZWE5YjAwODI3MGJjNzdjMDFlODgxODBjNCIsIm5iZiI6MTcyNjkzODk1Ni4zNzY1MTcsInN1YiI6IjY2ZWVmYmZiYjM0OGJlYTRlYjNiMWVlNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.gYjJbM43VIKFHQgIT8SX-3q-8FdDtk-aU2C3NnfMkJs"

    
    // Singleton instance if needed
    static let shared = APIClient()
    
    private init() {}
    
    // Fetch data from the given URL
    func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            // Handle error
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            // Check for response and data
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data else {
                let responseError = NSError(domain: "InvalidResponse", code: -1, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(responseError))
                }
                return
            }
            
            // Decode the data into the expected type
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        // Start the task
        task.resume()
    }
}
