import Foundation

public class WeatherClient {
    private let key: String
    private let http = HTTPClient(baseURL: URL(string: "https://api.openweathermap.org/data/2.5")!)
    private let decoder = JSONDecoder()

    private var cities: [City]?

    public init(key: String) {
        self.key = key

        let bundle = Bundle(for: type(of: self))
        if let url = bundle.url(forResource:"city.list.min", withExtension: "json"), let data = try? Data(contentsOf:url) {
            let decoder = JSONDecoder()
            cities = try? decoder.decode([City].self, from: data)
        }

        decoder.dateDecodingStrategy = .secondsSince1970
    }

    public func citiesSuggestions(for partialName: String) -> [City] {
        guard let cities = cities else { return [] }
        return cities.filter { $0.name.lowercased().contains(partialName.lowercased()) }
    }

    public func weather(for city: City, completion: @escaping (Forecast?) -> Void) {
        let request = http.request(method: .get, path: "/weather", queryParameters: defaultParams(for: city))
        http.start(request: request) { (response, data, error) in
            if let data = data {
                let weather = try! self.decoder.decode(APIWeather.self, from: data)
                let result = Forecast(api: weather)
                completion(result)
            } else {
                completion(nil)
            }
        }
    }

    public func forecast(for city: City, completion: @escaping ([Forecast]?) -> Void) {
        let request = http.request(method: .get, path: "/forecast", queryParameters: defaultParams(for: city))
        http.start(request: request) { (response, data, error) in
            if let data = data {
                let forecast = try! self.decoder.decode(APIForecast.self, from: data)
                let result = forecast.list.map { Forecast(api: $0) }
                completion(result)
            } else {
                completion(nil)
            }
        }
    }

    private func defaultParams(for city: City) -> [String: Any] {
        return ["APPID": key,
                "id": city.identifier,
                "units": "metric",
                "lang": Locale.current.languageCode ?? "en"
        ]
    }
}
