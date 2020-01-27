//
//  ViewController.swift
//  Promises
//
//  Created by Maksim Romanov on 27.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    var data = Data()
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        .map {data -> [Post] in
            let jsonDecoder = JSONDecoder()
            let posts = try jsonDecoder.decode([Post].self, from: data)
            return posts
        }.add(callback: { result in
            switch result {
            case .success(let posts):
                print(posts)
            case .failure(let error):
                print(error)
            }
        })
    }

    func fetchData() -> Promise<Data> {
        // Создаем исходный промис, который будет возвращать
        // Future<Data>, содержащую информацию о прогнозах погоды
        let promise = Promise<Data>()
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
       
        // Выполняем стандартный сетевой запрос
        URLSession.shared.dataTask(with: url) { data, _, error in
            // И в completion выполняем или нарушаем обещание
            if let error = error {
                promise.reject(with: error)
            } else {
                promise.fulfill(with: data ?? Data())
            }
        }.resume()
       
        return promise
       
    }
    
    func parseData(data: Data) -> [Post] {
        let json = JSON(data)
        let postsJSONs = json.arrayValue
        let posts = postsJSONs.map {Post(from: $0)}
        return posts
        }

}

