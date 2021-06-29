//
//  User.swift
//  gb-client_server-app
//
//  Created by Вячеслав Буринов on 29.06.2021.
//

import Foundation


class User: Decodable {
    var count: Int
    var items: [Item]

}

class Item: Decodable {
    var id: Int
    var first_name: String
    var last_name: String
    var is_closed: Bool
    var can_access_closed: Bool
    var domain: String
    var city: [City]
    var online: Int
    var track_code: String
}

class City: Decodable {
    var id: Int
    var title: String
}

struct API {
    
    let baseUrl = "https://api.vk.com/method"
    let token = Session.shared.token
    let clientId = Session.shared.userId
    let version = "5.131"
    
    private var session: URLSession
    
    func getFriends(completion: ([User])->()) {
        
        var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "api.vk.com"
            urlComponents.path = "/method/friends.get"
            urlComponents.queryItems = [
                URLQueryItem(name: "user_id", value: clientId),
                URLQueryItem(name: "order", value: "name"),
                URLQueryItem(name: "count", value: "100"),
                URLQueryItem(name: "fields", value: "photo_100"),
                URLQueryItem(name: "access_token", value: token),
                URLQueryItem(name: "v", value: version)
                ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                print(users)
            } catch {
                print(error)
            }

            
        }.resume()
        
        completion([])
    }
    
}
