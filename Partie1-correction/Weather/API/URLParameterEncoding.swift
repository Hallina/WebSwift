import Foundation

struct URLParameterEncoding {
    func encode(_ request: URLRequest, with parameters: [String: Any]?) -> URLRequest {
        guard let requestURL = request.url, let parameters = parameters, !parameters.isEmpty else {
            return request
        }
        var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        let existingItems = components?.queryItems ?? []
        components?.queryItems = existingItems + query(parameters)
        var request = request
        request.url = components?.url
        return request
    }

    private func query(_ parameters: [String: Any]) -> [URLQueryItem] {
        var components = [URLQueryItem]()

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryItems(fromKey: key, value: value)
        }
        return components
    }

    private func queryItems(fromKey key: String, value: Any) -> [URLQueryItem] {
        var items = [URLQueryItem]()
        if let array = value as? [Any] {
            let key = encode(arrayKey: key)
            for arrayValue in array {
                items += queryItems(fromKey: key, value: arrayValue)
            }
        } else if let boolValue = value as? Bool {
            items.append(URLQueryItem(name: key, value: encode(value: boolValue)))
        } else {
            items.append(URLQueryItem(name: key, value: "\(value)"))
        }
        return items
    }

    private func encode(value: Bool) -> String {
        return value ? "1" : "0"
    }

    private func encode(arrayKey key: String) -> String {
        return "\(key)[]"
    }
}
