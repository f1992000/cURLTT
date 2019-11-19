//
//  ViewController.swift
//  cURLTT
//
//  Created by  DARFON on 2019/11/18.
//  Copyright © 2019  DARFON. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        postRequest()
        let QQ = "*"
        getRequest(accessToken: QQ)
    }

    func postRequest(){
        // 这个session可以使用刚才创建的。
        let session = URLSession(configuration: .default)
        // 设置URL
        let url = "https://www.strava.com/oauth/token"
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        // 设置要post的内容，字典格式
        let postData = [
            "client_id":"*",
            "client_secret":"*",
            "code":"*",
            "grant_type":"authorization_code"
        ]
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        // 后面不解释了，和GET的注释一样
        let task = session.dataTask(with: request) {(data, response, error) in
            do {
                let r = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print(r)
                print("accessToken: \(r["access_token"]!)")
            } catch {
                print("无法连接到服务器")
                return
            }
        }
        task.resume()
    }
    
    
    func getRequest(accessToken:String){
        // 创建一个会话，这个会话可以复用
        let session = URLSession(configuration: .default)
        // 设置URL
        let url = "https://www.strava.com/api/v3/athlete"
        var UrlRequest = URLRequest(url: URL(string: url)!)
        UrlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        // 创建一个网络任务
        let task = session.dataTask(with: UrlRequest) {(data, response, error) in
            do {
                // 返回的是一个json，将返回的json转成字典r
                let r = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                print(r)
                print("ID: \(r["id"]!)")
            } catch {
                // 如果连接失败就...
                print("无法连接到服务器")
                return
            }
        }
        // 运行此任务
        task.resume()
    }
    
    
}

