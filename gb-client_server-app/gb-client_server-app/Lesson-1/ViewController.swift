//
//  ViewController.swift
//  gb-client_server-app
//
//  Created by Вячеслав Буринов on 17.06.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    
        
    @IBOutlet weak var webView: WKWebView!{
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestAuthorize()
        showToTabbar()
    }

    func requestAuthorize() {
        var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "oauth.vk.com"
            urlComponents.path = "/authorize"
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: "7887653"),
                URLQueryItem(name: "display", value: "mobile"),
                URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                URLQueryItem(name: "scope", value: "262150"),
                URLQueryItem(name: "response_type", value: "token"),
                URLQueryItem(name: "v", value: "5.131")
                ]
        
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
    }
    
}

    //MARK: WKNavigationDelegate

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        if let token = params["access_token"], let user_id = params["user_id"] {
            Session.shared.token = token
            Session.shared.userId = user_id
        }
        
        print(Session.shared.token)
        
        decisionHandler(.cancel)
    }
    
    func showToTabbar(){
        
        performSegue(withIdentifier: "performToTabbar", sender: nil)
    }
    
}
