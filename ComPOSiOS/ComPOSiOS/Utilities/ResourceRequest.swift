//
//  GetResourcesRequest.swift
//  ComPOSiOS
//
//  Created by Maxim Butin on 18/05/2019.
//  Copyright © 2019 Maxim Butin. All rights reserved.
//

import Foundation

enum GetResourcesRequest<ResourceType> {
    case success([ResourceType])
    case failure
}

struct ResourceRequest<ResourceType> where ResourceType: Codable {
    
    let baseURL = "http://localhost:8080/api/"
    let resourceURL: URL
    
    init(resourcePath: String) {
        guard let resouceURL = URL(string: baseURL) else { fatalError() }
        self.resourceURL = resouceURL.appendingPathComponent(resourcePath)
    }
    
    func getAll(completion: @escaping(GetResourcesRequest<ResourceType>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure)
                return
            }
            do {
                let resources = try JSONDecoder().decode([ResourceType].self, from: jsonData)
                completion(.success(resources))
            } catch {
                completion(.failure)
            }
        }
        dataTask.resume()
    }
}
