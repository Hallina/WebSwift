import Foundation

class HTTPClient {
    enum Method: String {
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
    }

    let baseURL: URL
    let session: URLSession

    let parameterEncoding = URLParameterEncoding()

    init(baseURL: URL) {
        self.baseURL = baseURL

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpMaximumConnectionsPerHost = 1
        sessionConfig.httpShouldSetCookies = false
        sessionConfig.httpCookieAcceptPolicy = .never
        sessionConfig.timeoutIntervalForRequest = 90

        session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    }

    func request(method: Method,
                 path: String,
                 queryParameters: [String: Any]? = nil,
                 body: Data? = nil) -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        request = parameterEncoding.encode(request, with: queryParameters)
        if let body = body {
            request.httpBody = body
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        return request
    }

    func start(request: URLRequest, completion: ((HTTPURLResponse?, Data?, Error?) -> Void)?) {
        var task: URLSessionDataTask!
        task = session.dataTask(with: request) { (data, response, error) in
            let data = data?.isEmpty ?? true ? nil : data
            let response = response as? HTTPURLResponse

            completion?(response, data, error)
        }

        task?.resume()
    }
}
