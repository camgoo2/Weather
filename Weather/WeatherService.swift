//
//  WeatherService.swift
//  Weather
//
//  Created by Cameron Goodhue on 2/06/24.
//

//import Foundation
////https://api.openweathermap.org/data/2.5/weather?q=Sydney&APPID=e62fcb58d7bc164dc93734ab87c211c0&units=metric
//The apikey does not need to be in the class to be called. Note as API keys should not be shared in any public repository.


//struct WeatherResponse: Codable {
//    let main: Main
//    let weather: [Weather]
//}
//
//struct Main: Codable {
//    let temp: Double
//}
//
//struct Weather: Codable {
//    let description: String
//}
//
//class WeatherService {
//    func fetchWeather(for city: String, completion: @escaping (WeatherResponse?) -> Void) {
//        
//         let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&APPID=\(apiKey)&units=metric"
//         
//        //completion(nil) followed by return exits us out of the function
//        //completion does not need to be used. could be completionHandler for example
//         guard let url = URL(string: urlString) else {
//             completion(nil)
//             return
//         }
//
//        URLSession.shared.dataTask(with: url) { data,response, error in
//            guard let data = data, error == nil else {
//                completion(nil)
//                return
//            }
//        
//            
//            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
//            completion(weatherResponse)
//        }.resume()
//    }
//}


      

