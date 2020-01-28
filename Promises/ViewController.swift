//
//  ViewController.swift
//  Promises
//
//  Created by Maksim Romanov on 27.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PromiseKit

class ViewController: UIViewController {

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
    /*
    func forecast(for city: String, on queue: DispatchQueue = .main) -> Promise<[Weather]> {
        let baseUrl = "https://api.openweathermap.org"
        let path = "/data/2.5/forecast"
       
        let params: Parameters = [
            "q": city,
            "units": "metric",
            "appId": "8b32f5f2dc7dbd5254ac73d984baf306"
        ]
       
        return Alamofire.request(baseUrl+path, method: .get, parameters: params)
            .responseJSON()
            .map(on: queue) { json, response -> [Weather] in
                let json = JSON(json)
               
                if let errorMessage = json["message"].string {
                    let error = WeatherError.cityNotFound(message: errorMessage)
                    throw error
                }
               
                let weathers = json["list"].arrayValue.map { Weather($0) }
                return weathers
        }
    }*/
    
    func fetchData() -> Promise<Data> {
        // Создаем исходный промис, который будет возвращать
        // Future<Data>, содержащую информацию о прогнозах погоды
        let promise = Promise<Data>()
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        //let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=Moscow&units=metric&appId=8b32f5f2dc7dbd5254ac73d984baf306")!
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

