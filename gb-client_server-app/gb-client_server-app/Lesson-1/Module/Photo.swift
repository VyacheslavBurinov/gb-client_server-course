//
//  Photo.swift
//  gb-client_server-app
//
//  Created by Вячеслав Буринов on 29.06.2021.
//
import Foundation

//"count": 213,
//"items": [{
//"id": 376599151,
//"album_id": -6,
//"owner_id": 1,
//"sizes": [{
//"src": "https://pp.vk.me/...52a/ivi7X4q9KlY.jpg",
//"width": 75,
//"height": 50,
//"type": "s"

struct Photo: Decodable {
    
    var count: Int
    var items: [ItemsPhoto]
    
}

struct ItemsPhoto: Decodable {
    
    var id: Int
    var album_id: Int
    var owner_id: Int
    var sizes: [Sizes]
    
}

struct Sizes: Decodable {
    var scr: String
    var width: Int
    var height: Int
    var type: String
}

struct APIPhoto {
    
    let token = Session.shared.token
    let clientId = Session.shared.userId
    let version = "5.131"
    
    private var session: URLSession
    
    func getGroups(completion: ([Photo])->()) {
        
        var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "api.vk.com"
            urlComponents.path = "/method/photos.getAll"
            urlComponents.queryItems = [
                URLQueryItem(name: "owner_id", value: clientId),
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "no_service_albums", value: "0"),
                URLQueryItem(name: "count", value: "50"),
                URLQueryItem(name: "access_token", value: token),
                URLQueryItem(name: "v", value: version)
                ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                print(photos)
            } catch {
                print(error)
            }

            
        }.resume()
        
        completion([])
    }
    
}
