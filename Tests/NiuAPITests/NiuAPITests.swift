import XCTest
@testable import NiuAPI

/******************************
 
 Fill out the sections *Account Infos* and *Access infos* to run all tests. 
 
*/


final class NiuAPITests: XCTestCase {
    
    // MARK: - Account Infos
    
    private let account = ""
    private let password = ""
    private let countryCode = 49
    
    // MARK: - Access infos
    
    private let accessToken: String = ""
    private let refreshToken: String = ""
    
    private let scooterSerialNumber: String = ""
    private let testTrackId: String = ""
    private let testTrackDate: Int = 20230501 // must be in the form: yyyymmdd
    
    
    // MARK: - Test functions
    
    func test_Login() async throws {
        do {
            let loginData = try await NiuAPI.login(with: account, password: password, countryCode: countryCode)
            
            XCTAssertEqual("\(countryCode)", loginData.user.country_code)
        } catch {
            guard let apiError = error as? NiuAPI.Errors else {
                print(error)
                XCTFail()
                return
            }
            
            print("Error: \(apiError.description)")
            XCTFail()
        }
    }
    
    func test_readVehicles() async throws {
        let vehicles = try await NiuAPI.vehicles(forUserWith: accessToken)
        
        XCTAssertEqual(vehicles.count, 1)
        
        XCTAssertEqual(vehicles.first?.sn, scooterSerialNumber)
    }
    
    func test_currentPositionOfVehicle() async throws {
        let currentPosition = try await NiuAPI.currentPosition(forVehicleWith: scooterSerialNumber, accessToken: accessToken)

        XCTAssertEqual(currentPosition.gps, 5)
        XCTAssertEqual(currentPosition.gpsPrecision, 1)
    }
    
    func test_overallTelly() async throws {
        let overallTally = try await NiuAPI.overallTally(forVehicleWith: scooterSerialNumber, accessToken: accessToken)

        XCTAssertTrue(overallTally.bindDaysCount >= 600)
    }
    
    func test_readTrackList() async throws {
        let trackList = try await NiuAPI.tracks(forVehicleWith: scooterSerialNumber, take: 2, skip: 0, accessToken: accessToken)

        XCTAssertEqual(trackList.items.count, 2)
    }
    
    func test_readTrackDetails() async throws {
        let trackDetail = try await NiuAPI.detailTrack(forVehicleWith: scooterSerialNumber, trackId: testTrackId, trackDate: testTrackDate, accessToken: accessToken)

        XCTAssertEqual(trackDetail.trackItems.count, 203)
    }
    
    func test_readBatteryInformation() async throws {
        let batteryInformation = try await NiuAPI.batteryInformation(forVehicleWith: scooterSerialNumber, accessToken: accessToken)

        XCTAssertEqual(batteryInformation.isCharging, false)
    }
    
    func test_readBatteryHealth() async throws {
        let batteryHealth = try await NiuAPI.batteryHealth(forVehicleWith: scooterSerialNumber, accessToken: accessToken)

        XCTAssertTrue(batteryHealth.isDoubleBattery)
    }
    
    func test_batteryChart() async throws {
        let batteryChartData = try await NiuAPI.batteryChart(forVehicleWith: scooterSerialNumber, andBattery: 1, page: 1, pageSize: "A", accessToken: accessToken)
        
        XCTAssertEqual(batteryChartData.items1.count, 95)
    }
    
    func test_readMotorInfo() async throws {
        let motorInfo = try await NiuAPI.motorInfo(forVehicleWith: scooterSerialNumber, accessToken: accessToken)

        XCTAssertEqual(motorInfo.ss_protocolVersion, 3)
        XCTAssertEqual(motorInfo.ss_onlineStatus, "1")
    }
}
