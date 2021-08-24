import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(with error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/find?appid=1da933c9c6cec3a04d586145291e478f&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(_ city:String) {
    let c = city.replacingOccurrences(of: " ", with: "%20")
    let url = URL(string: "\(weatherURL)&q=\(c)")!
    performRequest(with: url)
    }
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let url = URL(string: "\(weatherURL)&lat=\(lat)&lon=\(lon)")!
        performRequest(with: url)
    }
    
    func performRequest(with url: URL) {
        let task = URLSession(configuration: .default)
            .dataTask(with: url, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
                if error != nil {
                    self.delegate?.didFailWithError(with: error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(WeatherData.self, from: safeData)
                        let id = decodedData.list[0].weather[0].id
                        let temp = decodedData.list[0].main.temp
                        let name = decodedData.list[0].name
                        
                        let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    } catch {
                        self.delegate?.didFailWithError(with: error)
                    }
                }
            })
        task.resume()
    }
}
