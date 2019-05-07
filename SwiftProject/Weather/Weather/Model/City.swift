import Foundation

public struct City: Codable {
    let identifier: Int64
    let name: String
    let country: String

    enum CodingKeys : String, CodingKey {
        case identifier = "id"
        case name
        case country
    }
}
