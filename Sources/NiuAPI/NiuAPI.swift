//
//  NiuAPI.swift
//
//  Created by Andre Albach on 07.05.23.
//

import Foundation

/// User agent as in the official Niu app for iOS
fileprivate let userAgent = "manager/4.10.4 (iPhone; iOS 16.4.1);brand=Unknown;model=Unknown;clientIdentifier=Overseas;lang=en-US"


/// Private extension for the http methode
fileprivate extension URLRequest {
    enum HTTPMethod: String, Equatable {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
    }
}

/// Namespace for all the API functions
public enum NiuAPI {
    
    /// The url address for account related api calls, like log in
    static private let accountBaseURL = "https://account-fk.niu.com"
    
    /// The url address for the api calls
    static private let baseURL = "https://app-api-fk.niu.com"
    
    
    /// This function will create the urlRequest
    /// It will always set: User-Agent, Host, Accept, Connection, Accept-Encoding, Content-Type
    /// - Parameters:
    ///   - url: The URL for the request
    ///   - userAgent: The user agent to use
    ///   - accessToken: The access token of the user. Only needed for some requests
    ///   - httpMethode: The http methode to use
    /// - Returns: The resulting URL request
    private static func urlRequest(url: URL,
                                   userAgent: String,
                                   accessToken: String? = nil,
                                   httpMethode: URLRequest.HTTPMethod = .get) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        request.addValue("keep-alive", forHTTPHeaderField: "Connection")
        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let accessToken = accessToken {
            request.addValue(accessToken, forHTTPHeaderField: "token")
        }
        
        if httpMethode == .post || httpMethode == .put {
            request.httpMethod = httpMethode.rawValue
        }
        
        return request
    }
    
    /// This function will create the urlRequest
    /// It will always set: User-Agent, Host, Accept, Connection, Accept-Encoding, Content-Type
    /// - Parameters:
    ///   - url: The URL for the request
    ///   - userAgent: The user agent to use
    ///   - accessToken: The access token of the user. Only needed for some requests
    ///   - httpMethode: The http methode to use
    ///   - body: The body which should be added. This Dictionary will be transformed to a JSON string
    /// - Returns: The resulting URL request
    private static func urlRequest(url: URL,
                                   userAgent: String,
                                   accessToken: String? = nil,
                                   httpMethode: URLRequest.HTTPMethod = .get,
                                   body: [String: Any]? = nil) throws -> URLRequest {
        
        var request = urlRequest(url: url, userAgent: userAgent, accessToken: accessToken, httpMethode: httpMethode)
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        return request
    }
    
    
    /// A list of all the errors which can occour when using this API
    public enum Errors: Error, CustomStringConvertible {
        case unmodified //304
        case badRequest //400
        case unauthorized //401
        case forbidden //402
        case notFound //404
        case conflict //409
        case unprocessableEntity //422
        case tooManyRequests //429
        case internalServerError //500
        
        case badURL
        
        case response
        case decoding(String)
        
        case describingError(String)
        
        
        public var description: String {
            switch self {
            case .unmodified:
                return "There is no new data. Content is unmodified."
            case .badRequest:
                return "Bad Request (400)"
            case .unauthorized:
                return "Unauthorized (401)"
            case .forbidden:
                return "Forbidden (403)"
            case .notFound:
                return "Not Found (404)"
            case .conflict:
                return "Conflict (409)"
            case .unprocessableEntity:
                return "Unprocessable Entity (422)"
            case .tooManyRequests:
                return "Too Many Requests (429)"
            case .internalServerError:
                return "Internal Server Error (500)"
                
            case .badURL:
                return "Bad URL"
                
            case .response:
                return "Unknown error with response"
            case .decoding(let error):
                return "Error while decoding. \(error)"
                
            case .describingError(let errorDescription):
                return errorDescription
            }
        }
        
        public var localizedDescription: String { description }
    }
    
    /// A helper function for checking the status code
    /// - Parameter statusCode: The status code to check
    static private func checkStatusCode(_ statusCode: Int) throws {
        switch statusCode {
        case 304: throw Errors.unmodified
        case 400: throw Errors.badRequest
        case 401: throw Errors.unauthorized
        case 403: throw Errors.forbidden
        case 404: throw Errors.notFound
        case 409: throw Errors.conflict
        case 422: throw Errors.unprocessableEntity
        case 429: throw Errors.tooManyRequests
        case 500: throw Errors.internalServerError
            
        case 200, 201, 204: return
            
        default: throw Errors.response
        }
    }
    
    /// A helper function to check the response and the data it comes with it
    /// - Parameters:
    ///   - data: The data which comes with the response
    ///   - response: The HTTP response object
    static private func checkResponseWith(data: Data, response: HTTPURLResponse) throws {
        do {
            try checkStatusCode(response.statusCode)
        } catch {
            let _error = error as! Errors
            
            /// Try to read the exception message from the general error. Default with complete error description
            let json: [String: Any]?
            do {
                json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                
            } catch {
                guard let dataString = String(data: data, encoding: .utf8) else { throw _error }
                throw Errors.describingError("\(_error.description)\n\n\(dataString)")
            }
            
            if let exceptionMessage = json?["ExceptionMessage"] as? String {
                throw Errors.describingError(exceptionMessage)
            } else if let message = json?["Message"] as? String {
                throw Errors.describingError(message)
            } else {
                guard let dataString = String(data: data, encoding: .utf8) else { throw _error }
                throw Errors.describingError("\(_error.description)\n\n\(dataString)")
            }
        }
    }
}



// MARK: - Async Functions

public extension NiuAPI {
    
    // MARK: - Login
    
#if canImport(CryptoKit)
    
    /// Will log in and return an access token
    /// - Parameters:
    ///   - account: Can be a email address or phone number or user name. Whatever is registered
    ///   - password: The password connected to the `account`. This must be the plain password. It will then be md5 hashed inside this function
    ///   - countryCode: The country code as in phone numbers. Without leadings zeros. Use 49 for Germany.
    /// - Returns: The log in response information
    static func login(with account: String, password: String, countryCode: Int) async throws -> LoginResponse {
        let body: [String : Any] = [
            "app_id" : "niu_fksss2ws",
            "grant_type" : "password",
            "scope" : "base",
            "account" : account,
            "password" : password.md5,
            "countryCode" : countryCode
        ]
        
        return try await _login(with: body)
    }
    
#endif
    
    /// Will log in and return an access token
    /// - Parameters:
    ///   - account: Can be a email address or phone number or user name. Whatever is registered
    ///   - md5HashedPassword: The md5 hash value of the password connected to the `account`.
    ///   - countryCode: The country code as in phone numbers. Without leadings zeros. Use 49 for Germany.
    /// - Returns: The log in response information
    static func login(with account: String, md5HashedPassword: String, countryCode: Int) async throws -> LoginResponse {
        let body: [String : Any] = [
            "app_id" : "niu_fksss2ws",
            "grant_type" : "password",
            "scope" : "base",
            "account" : account,
            "password" : md5HashedPassword,
            "countryCode" : countryCode
        ]
        
        return try await _login(with: body)
    }
    
    /// Will log in and return an access token
    /// - Parameter body: The body which is needed to log in. It should provide information about: `app_id`, `grant_type`, `scope`, `account`, `password` and `countryCode`
    /// - Returns: The log in response information
    private static func _login(with body: [String : Any]) async throws -> LoginResponse {
        var components = URLComponents(string: accountBaseURL)!
        components.path = "/v3/api/oauth2/token"
        
        guard let url = components.url else { throw Errors.badURL }
        
        let request = try urlRequest(url: url, userAgent: userAgent, httpMethode: .post, body: body)
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request, delegate: nil)
        
        guard let response = urlResponse as? HTTPURLResponse else { throw Errors.response }
        
        try checkResponseWith(data: data, response: response)
        
        
        struct _LoginResponse: Codable {
            let data: LoginResponse?
            let desc: String
            let status: Int
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                do {
                    self.data = try container.decodeIfPresent(LoginResponse.self, forKey: .data)
                } catch {
                    /// Some special handling here, because server might return `{}` instead of `null` when data is not there
                    self.data = nil
                }
                self.desc = try container.decode(String.self, forKey: .desc)
                self.status = try container.decode(Int.self, forKey: .status)
            }
        }
        
        
        let loginResponse: _LoginResponse
        do {
            loginResponse = try JSONDecoder().decode(_LoginResponse.self, from: data)
        } catch {
            throw Errors.decoding(error.localizedDescription)
        }
        
        guard loginResponse.status == 0,
              let data = loginResponse.data else {
            throw Errors.describingError(loginResponse.desc)
        }
        
        return data
    }
    
    
    // MARK: - Vehicles
    
    /// Will return the list of vehicles which are connected to the user linked with the `token`
    /// - Parameter accessToken: The access token of the user
    /// - Returns: The list of vehicles the user has
    static func vehicles(forUserWith accessToken: String) async throws -> [Vehicle] {
        var components = URLComponents(string: baseURL)!
        components.path = "/motoinfo/list"
        
        guard let url = components.url else { throw Errors.badURL }
        
        let request = urlRequest(url: url, userAgent: userAgent, accessToken: accessToken, httpMethode: .post)
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request, delegate: nil)
        
        guard let response = urlResponse as? HTTPURLResponse else { throw Errors.response }
        
        try checkResponseWith(data: data, response: response)
        
        struct VehiclesResponse: Codable {
            let data: [Vehicle]
            let desc: String
            let trace: String
            let status: Int
        }
        
        do {
            return try JSONDecoder().decode(VehiclesResponse.self, from: data).data
        } catch {
            throw Errors.decoding(error.localizedDescription)
        }
    }
    
    /// Will return the current position of the vehicle with `serialNumber`
    /// - Parameters:
    ///   - serialNumber: The serial number for the vehicle for which the position is needed
    ///   - accessToken: The access token of the user
    /// - Returns: The current position information
    static func currentPosition(forVehicleWith serialNumber: String, accessToken: String) async throws -> Position {
        var components = URLComponents(string: baseURL)!
        components.path = "/motoinfo/currentpos"
        
        guard let url = components.url else { throw Errors.badURL }
        
        let body: [String : Any] = [
            "sn" : serialNumber
        ]
        
        let request = try urlRequest(url: url, userAgent: userAgent, accessToken: accessToken, httpMethode: .post, body: body)
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request, delegate: nil)
        
        guard let response = urlResponse as? HTTPURLResponse else { throw Errors.response }
        
        try checkResponseWith(data: data, response: response)
        
        struct PositionResponse: Codable {
            let data: Position
            let desc: String
            let trace: String
            let status: Int
        }
        
        do {
            return try JSONDecoder().decode(PositionResponse.self, from: data).data
        } catch {
            throw Errors.decoding(error.localizedDescription)
        }
    }
    
    /// Will return the total tally information for the vehicle with `serialNumber`
    /// - Parameters:
    ///   - serialNumber: The serial number for the vehicle for which the total tally information are needed
    ///   - accessToken: The access token of the user
    /// - Returns: The total tally information for the vehicle
    static func overallTally(forVehicleWith serialNumber: String, accessToken: String) async throws -> OverallTally {
        var components = URLComponents(string: baseURL)!
        components.path = "/motoinfo/overallTally"
        
        guard let url = components.url else { throw Errors.badURL }
        
        let body: [String : Any] = [
            "sn" : serialNumber
        ]
        
        let request = try urlRequest(url: url, userAgent: userAgent, accessToken: accessToken, httpMethode: .post, body: body)
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request, delegate: nil)
        
        guard let response = urlResponse as? HTTPURLResponse else { throw Errors.response }
        
        try checkResponseWith(data: data, response: response)
        
        struct OverallTallyResponse: Codable {
            let data: OverallTally
            let desc: String
            let trace: String
            let status: Int
        }
        
        do {
            return try JSONDecoder().decode(OverallTallyResponse.self, from: data).data
        } catch {
            throw Errors.decoding(error.localizedDescription)
        }
    }
    
    
    // MARK: - Tracks
    
    /// Will read a list of tracks
    /// - Parameters:
    ///   - serialNumber: The serial number for the vehicle for which the track list is needed
    ///   - take: The amount of tracks the list should contain
    ///   - skip: The amount of tracks which should be skipped
    ///   - accessToken: The access token of the user
    /// - Returns: The track list matching the provided `take` and `skip` information
    static func tracks(forVehicleWith serialNumber: String, take: Int, skip: Int, accessToken: String) async throws -> TrackList {
        var components = URLComponents(string: baseURL)!
        components.path = "/v5/track/list/v2"
        
        guard let url = components.url else { throw Errors.badURL }
        
        let body: [String : Any] = [
            "sn" : serialNumber,
            "index" : "\(skip)",
            "pagesize" : take,
            "token" : accessToken
        ]
        
        let request = try urlRequest(url: url, userAgent: userAgent, accessToken: accessToken, httpMethode: .post, body: body)
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request, delegate: nil)
        
        guard let response = urlResponse as? HTTPURLResponse else { throw Errors.response }
        
        try checkResponseWith(data: data, response: response)
        
        struct TracksResponse: Codable {
            let data: TrackList
            let desc: String
            let trace: String
            let status: Int
        }
        
        do {
            return try JSONDecoder().decode(TracksResponse.self, from: data).data
        } catch {
            throw Errors.decoding(error.localizedDescription)
        }
    }
    
    /// Will read detailed track information
    /// - Parameters:
    ///   - serialNumber: The serial number for the vehicle for which the detailed track information are needed
    ///   - trackId: The id of the track for which detail information are needed
    ///   - trackDate: The date of the track for which detailed information are needed. Has the form yyyymmdd
    ///   - accessToken: The access token of the user
    /// - Returns: The detailed track information
    static func detailTrack(forVehicleWith serialNumber: String, trackId: String, trackDate: Int, accessToken: String) async throws -> TrackDetail {
        var components = URLComponents(string: baseURL)!
        components.path = "/v5/track/detail"
        
        guard let url = components.url else { throw Errors.badURL }
        
        let body: [String : Any] = [
            "sn" : serialNumber,
            "trackId" : trackId,
            "date" : "\(trackDate)",
            "token" : accessToken
        ]
        
        let request = try urlRequest(url: url, userAgent: userAgent, accessToken: accessToken, httpMethode: .post, body: body)
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request, delegate: nil)
        
        guard let response = urlResponse as? HTTPURLResponse else { throw Errors.response }
        
        try checkResponseWith(data: data, response: response)
        
        struct TrackDetailResponse: Codable {
            let data: TrackDetail
            let desc: String
            let trace: String
            let status: Int
        }
        
        do {
            return try JSONDecoder().decode(TrackDetailResponse.self, from: data).data
        } catch {
            throw Errors.decoding(error.localizedDescription)
        }
    }
    
    
    // MARK: - Battery
    
    /// Will return the battery information
    /// - Parameters:
    ///   - serialNumber: The serial number for the vehicle for which the battery information are needed
    ///   - accessToken: The access token of the user
    /// - Returns: The battery information for the vehicle
    static func batteryInformation(forVehicleWith serialNumber: String, accessToken: String) async throws -> BatteryInfo {
        var components = URLComponents(string: baseURL)!
        components.path = "/v3/motor_data/battery_info"
        
        components.queryItems = [
            URLQueryItem(name: "sn", value: serialNumber)
        ]
        
        guard let url = components.url else { throw Errors.badURL }
        
        let request = urlRequest(url: url, userAgent: userAgent, accessToken: accessToken)
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request, delegate: nil)
        
        guard let response = urlResponse as? HTTPURLResponse else { throw Errors.response }
        
        try checkResponseWith(data: data, response: response)
        
        struct BatteryInformationResponse: Codable {
            let data: BatteryInfo
            let desc: String
            let trace: String
            let status: Int
        }
        
        do {
            return try JSONDecoder().decode(BatteryInformationResponse.self, from: data).data
        } catch {
            throw Errors.decoding(error.localizedDescription)
        }
    }
    
    /// Will return the battery health information for the vehicle with the passed in `serialNumber`
    /// - Parameters:
    ///   - serialNumber: The serial number for the vehicle for which the battery health is needed
    ///   - accessToken: The access token of the user
    /// - Returns: The battery health for the vehicle
    static func batteryHealth(forVehicleWith serialNumber: String, accessToken: String) async throws -> BatteryHealth {
        var components = URLComponents(string: baseURL)!
        components.path = "/v3/motor_data/battery_info/health"
        
        components.queryItems = [
            URLQueryItem(name: "sn", value: serialNumber)
        ]
        
        guard let url = components.url else { throw Errors.badURL }
        
        let request = urlRequest(url: url, userAgent: userAgent, accessToken: accessToken)
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request, delegate: nil)
        
        guard let response = urlResponse as? HTTPURLResponse else { throw Errors.response }
        
        try checkResponseWith(data: data, response: response)
        
        struct BatteryHealthResponse: Codable {
            let data: BatteryHealth
            let desc: String
            let trace: String
            let status: Int
        }
        
        do {
            return try JSONDecoder().decode(BatteryHealthResponse.self, from: data).data
        } catch {
            throw Errors.decoding(error.localizedDescription)
        }
    }
    
    /// Will return battery chart information
    /// - Parameters:
    ///   - serialNumber: The serial number for the vehicle for which the battery chart is needed
    ///   - bmsId: The battery: 1: Battery A; 2: Battery B
    ///   - page: The page number selects the data. Start always with 1
    ///   - pageSize: "A" or "B". It looks like "B" provides more information than "A"
    ///   - accessToken: The access token of the user
    /// - Returns: The battery chart data
    static func batteryChart(forVehicleWith serialNumber: String, andBattery bmsId: Int, page: Int, pageSize: String, accessToken: String) async throws -> BatteryChartData {
        var components = URLComponents(string: baseURL)!
        components.path = "/v3/motor_data/battery_chart"
        
        components.queryItems = [
            URLQueryItem(name: "sn", value: serialNumber),
            URLQueryItem(name: "bmsId", value: "\(bmsId)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "page_size", value: pageSize),
            URLQueryItem(name: "pageLength", value: "1") /// If set to 2, the response will include 2 arrays with data points.
        ]
        
        guard let url = components.url else { throw Errors.badURL }
        
        let request = urlRequest(url: url, userAgent: userAgent, accessToken: accessToken)
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request, delegate: nil)
        
        guard let response = urlResponse as? HTTPURLResponse else { throw Errors.response }
        
        try checkResponseWith(data: data, response: response)
        
        struct BatteryChartResponse: Codable {
            let data: BatteryChartData
            let desc: String
            let trace: String
            let status: Int
        }
        
        do {
            return try JSONDecoder().decode(BatteryChartResponse.self, from: data).data
        } catch {
            throw Errors.decoding(error.localizedDescription)
        }
    }
    
    
    
    // MARK: - Motor infos
    
    /// THe motor information of the vehicle with the passed in `serialumber`
    /// - Parameters:
    ///   - serialNumber: The serial number for the vehicle for which the motor information are needed
    ///   - accessToken: The access token of the user
    /// - Returns: The motor information for the vehicle
    static func motorInfo(forVehicleWith serialNumber: String, accessToken: String) async throws -> MotorInformation {
        var components = URLComponents(string: baseURL)!
        components.path = "/v3/motor_data/index_info"
        
        components.queryItems = [
            URLQueryItem(name: "sn", value: serialNumber)
        ]
        
        guard let url = components.url else { throw Errors.badURL }
        
        let request = urlRequest(url: url, userAgent: userAgent, accessToken: accessToken)
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request, delegate: nil)
        
        guard let response = urlResponse as? HTTPURLResponse else { throw Errors.response }
        
        try checkResponseWith(data: data, response: response)
        
        struct MotorInfoResponse: Codable {
            let data: MotorInformation
            let desc: String
            let trace: String
            let status: Int
        }
        
        do {
            return try JSONDecoder().decode(MotorInfoResponse.self, from: data).data
        } catch {
            throw Errors.decoding(error.localizedDescription)
        }
    }
}
