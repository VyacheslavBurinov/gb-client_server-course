//
//  Session.swift
//  gb-client_server-app
//
//  Created by Вячеслав Буринов on 17.06.2021.
//

import Foundation
import UIKit

final class Session {
    
    private init() {
    }
    
    static let shared = Session()
    
    var token: String = ""
    var userId: String = ""
    
}
