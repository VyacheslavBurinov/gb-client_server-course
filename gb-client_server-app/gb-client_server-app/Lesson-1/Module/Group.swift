//
//  Group.swift
//  gb-client_server-app
//
//  Created by Вячеслав Буринов on 29.06.2021.
//

import Foundation

//"count": 616,
//"items": [{
//"id": 31480508,
//"name": "Пикабу",
//"screen_name": "pikabu",
//"is_closed": 0,
//"type": "page",
//"is_admin": 0,
//"is_member": 1,
//"is_advertiser": 0,
//"photo_50": "https://sun9-5.us...i7F9_vu-8.jpg?ava=1",
//"photo_100": "https://sun9-17.u...1fqgM7UiI.jpg?ava=1",
//"photo_200": "https://sun9-3.us...vQJ6Gew98.jpg?ava=1"

struct Group: Decodable {
    
    var count: Int
    var items: [Items]
    
}

struct Items: Decodable {
    
    var id: Int
    var name: String
    var screen_name: String
    var is_closed: Int
    var type: String
    var is_admin: Int
    var is_member: Int
    var is_advertiser: Int
    var photo_100: String
    
}

struct APIGroup {
    
    let token = Session.shared.token
    let clientId = Session.shared.userId
    let version = "5.131"
    
    private var session: URLSession
    
    func getGroups(completion: ([Group])->()) {
        
        var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "api.vk.com"
            urlComponents.path = "/method/groups.get"
            urlComponents.queryItems = [
                URLQueryItem(name: "user_id", value: clientId),
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "access_token", value: token),
                URLQueryItem(name: "v", value: version)
                ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let groups = try JSONDecoder().decode([Group].self, from: data)
                print(groups)
            } catch {
                print(error)
            }

            
        }.resume()
        
        completion([])
    }
    
}
