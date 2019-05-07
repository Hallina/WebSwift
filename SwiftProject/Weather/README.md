#  Weather

Basic Swift (iOS) client for Open Weather Map

## How to use?

### Manual integration
1. Download [latest release](https://github.com/adhumi/Weather/releases)
2. Unarchive and drag and drop `Weather.framework` Xcode's "Linked Frameworks and Libraries" section

### Usage
1. Use `import Weather`
2. Initialize `WeatherClient` with you Open Weather Map API Key :
```
let weatherClient = WeatherClient(key: "YOUR_API_KEY")
```
3. Use the provided methods to request the API

## Documentation

#### `func citiesSuggestions(for partialName: String) -> [City]`
Returns an array of `City` matching the provided name

#### `func weather(for city: City, completion: @escaping (Forecast?) -> Void)`
Asynchronously query the current weather informations for the provided `City`. Completion provides a `Forecast` or nil.

#### `func forceast(for city: City, completion: @escaping ([Forecast]?) -> Void)`
Asynchronously query a 5-day weather forecast for the provided `City`. Completion provides a `Forecast` array or nil.
