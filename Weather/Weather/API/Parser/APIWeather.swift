import Foundation

struct APIWeather: Codable {
    struct Metrics: Codable {
        let temperature: Float
        let temperatureMin: Float
        let temperatureMax: Float
        let pressure: Float
        let humidity: Float

        enum CodingKeys : String, CodingKey {
            case temperature = "temp"
            case temperatureMin = "temp_min"
            case temperatureMax = "temp_max"
            case pressure
            case humidity
        }
    }

    struct Weather: Codable {
        let identifier: Int
        let title: String
        let description: String
        let icon: String

        enum CodingKeys : String, CodingKey {
            case identifier = "id"
            case title = "main"
            case description
            case icon
        }
    }

    struct Clouds: Codable {
        let coverage: Float

        enum CodingKeys : String, CodingKey {
            case coverage = "all"
        }
    }

    struct Wind: Codable {
        let speed: Float
        let orientation: Float

        enum CodingKeys : String, CodingKey {
            case speed
            case orientation = "deg"
        }
    }

    let date: Date
    let metrics: Metrics
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind

    enum CodingKeys : String, CodingKey {
        case date = "dt"
        case metrics = "main"
        case weather
        case clouds
        case wind
    }
}
