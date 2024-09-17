//
//  NetworkManager.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/14/24.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    

    func fetch<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        
        var urlComponents = URLComponents(string: endpoint.baseURL + endpoint.path)!
        
        urlComponents.queryItems = endpoint.queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        print("✅ url: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("네트워크 에러")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("data fetch 실패")
                completion(.failure(NetworkError.dataFetchFail))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                print("디코딩 실패")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
