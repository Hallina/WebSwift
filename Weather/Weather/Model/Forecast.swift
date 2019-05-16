import Foundation

public struct Forecast {
    let date: Date

    let temperature: Float
    let temperatureMin: Float
    let temperatureMax: Float
    let pressure: Float
    let humidity: Float

    let weather: [(title: String, description: String, icon: UIImage?)]

    let cloudsCoverage: Float

    let windSpeed: Float
    let windOrientation: Float

    internal init(api: APIWeather) {
        date = api.date

        temperature = api.metrics.temperature
        temperatureMin = api.metrics.temperatureMin
        temperatureMax = api.metrics.temperatureMax
        pressure = api.metrics.pressure
        humidity = api.metrics.humidity

        weather = api.weather.map {
            let icon = UIImage(named: $0.icon, in: Bundle(for: WeatherClient.self), compatibleWith: nil)
            return (title: $0.title, description: $0.description, icon: icon)
        }

        cloudsCoverage = api.clouds.coverage / 100.0

        windSpeed = api.wind.speed
        windOrientation = api.wind.orientation
    }

    internal init(api: APIForecast.ForecastItem) {
        date = api.date

        temperature = api.metrics.temperature
        temperatureMin = api.metrics.temperatureMin
        temperatureMax = api.metrics.temperatureMax
        pressure = api.metrics.pressure
        humidity = api.metrics.humidity

        weather = api.weather.map {
            let icon = UIImage(named: $0.icon, in: Bundle(for: WeatherClient.self), compatibleWith: nil)
            return (title: $0.title, description: $0.description, icon: icon)
        }

        cloudsCoverage = api.clouds.coverage / 100.0

        windSpeed = api.wind.speed
        windOrientation = api.wind.orientation
    }
}
