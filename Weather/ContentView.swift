import SwiftUI

struct ContentView: View {
    @State private var weatherResponse: WeatherResponse?
    @State private var city: String = ""
    let apiKey = "e62fcb58d7bc164dc93734ab87c211c0"

    var body: some View {
        ZStack{
            backgroundColor
                     .edgesIgnoringSafeArea(.all) 
            VStack {
                if let weather = weatherResponse {
                    Text("\(weather.main.temp, specifier: "%.1f")°C")
                        .font(.largeTitle)
                        .padding()
                    
                    HStack {
                        Text("High: \(weather.main.tempMax, specifier: "%.1f")°C")
                        Text("Low: \(weather.main.tempMin, specifier: "%.1f")°C")
                    }
                    .font(.title)
                    
                    ForEach(weather.weather.indices, id: \.self) { index in
                        HStack {
                            Text(weather.weather[index].emoji)
                            Text(weather.weather[index].description.capitalized)
                        }
                        .font(.title)
                        .padding()
                    }
                } else {
                    Text("Enter a city name to get the weather")
                        .font(.title)
                        .padding()
                }
                
                TextField("Enter city name", text: $city)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Get Weather") {
                    Task {
                        await fetchWeather()
                    }
                }
                .padding()
                .font(.largeTitle)
            }
            .padding()
            
        }
    }
    
    var backgroundColor: Color {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6..<12:
            return Color.blue.opacity(0.3) // Morning
        case 12..<18:
            return Color.yellow.opacity(0.3) // Afternoon
        case 18..<21:
            return Color.orange.opacity(0.3) // Evening
        case 21..<24, 0..<6:
            return Color.black.opacity(0.3) // Night
        default:
            return Color.gray.opacity(0.3) // Default
        }
    }

    func fetchWeather() async {
        do {
            weatherResponse = try await getWeather()
        } catch ResponseError.invalidRequest {
            print("Invalid Request")
        } catch ResponseError.invalidData {
            print("Invalid Data")
        } catch {
            print("Unexpected Error: \(error)")
        }
    }

    func getWeather() async throws -> WeatherResponse {
        let endpoint = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&APPID=\(apiKey)&units=metric"
        
        guard let url = URL(string: endpoint) else {
            throw ResponseError.invalidRequest
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ResponseError.invalidRequest
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(WeatherResponse.self, from: data)
        } catch {
            throw ResponseError.invalidData
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]

    struct Main: Codable {
        let temp: Double
        let tempMin: Double
        let tempMax: Double
    }

    struct Weather: Codable {
        let description: String
        
        var emoji: String {
            return WeatherDescription(rawValue: description)?.emoji ?? "❓"
        }
    }
}

enum WeatherDescription: String {
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case scatteredClouds = "scattered clouds"
    case brokenClouds = "broken clouds"
    case showerRain = "shower rain"
    case rain = "rain"
    case thunderstorm = "thunderstorm"
    case snow = "snow"
    case mist = "mist"
    case lightRain = "light rain"
    case overcastClouds = "overcast clouds"

    var emoji: String {
        switch self {
        case .clearSky:
            return "☀️"
        case .fewClouds:
            return "🌤"
        case .scatteredClouds:
            return "☁️"
        case .brokenClouds:
            return "🌥"
        case .showerRain:
            return "🌧"
        case .rain:
            return "🌦"
        case .thunderstorm:
            return "⛈"
        case .snow:
            return "❄️"
        case .mist:
            return "🌫"
        case .lightRain:
            return "🌧"
        case .overcastClouds:
            return "☁️"
        
        }
    }
}

enum ResponseError: Error {
    case invalidRequest
    case invalidData
}

