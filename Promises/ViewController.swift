//
//  ViewController.swift
//  Promises
//
//  Created by Maksim Romanov on 27.01.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(fetchWeatherData())
    }

    func fetchWeatherData() -> Promise<Data> {
        // Создаем исходный промис, который будет возвращать
        // Future<Data>, содержащую информацию о прогнозах погоды
        let promise = Promise<Data>()
       
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=Moscow&units=metric&appId=8b32f5f2dc7dbd5254ac73d984baf944")!
       
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

}

