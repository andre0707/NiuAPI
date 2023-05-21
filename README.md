# NiuAPI

This is a `Swift` API wrapper for the *Niu-Scooter* API.
It is based on the `Codable` protocol and provides `structs` for each type.
The variable names are names as in the API. 

Niu is a brand which produces electric scooter 🛵. See [website](https://niu.com).

This package is not completly covering the whole API.
However, it should cover the mose common used functions you might be interested in.

If you miss something or something is not working, feel free to write an issue or open a pull request.


## How to use this package

All API functions are static methods on the `NiuAPI` enum. 

You should start with logging in to get an access token.
In this example we will use a phone number (+49 151 1234567) to log in. You can also use your user name or email. Whatever you used for registration.
The password must be your plain password. It will be md5 hashed inside the login function. Only the hash will then be send to the server.

```
let myAccount = "1511234567" // Do not add the country code at the beginning
let password = "mySuperSecretPassword"
let countryCode = 49 // The country code as in phone numbers. Without leadings zeros. In our example it is 49 for Germany 

let loginData = try await NiuAPI.login(with: account, password: password, countryCode: countryCode)

let accessToken = loginData.token.access_token
let refreshToken = loginData.token.refresh_token 
```

For most of the API functions you will need to provide the serial number of the vehicle for which you want the get information.
You can get a list of all the vehicles of the logged in user like so:
```
let userVehicles = try await NiuAPI.vehicles(forUserWith: accessToken)
let myScooter = userVehicles[0]
let scooterSerialNumber = myScooter.sn 
```

This is how you can get the status of your vehicle:
```
let motorInfo = try await NiuAPI.motorInfo(forVehicleWith: scooterSerialNumber, accessToken: accessToken)
let isCharging = motorInfo.isCharging == 1
let estimatedMileage = motorInfo.estimatedMileage // This is in km
let chargingLevelBatteryA = motorInfo.batteries.compartmentA.batteryCharging // In percentage
let chargingLevelBatteryB = motorInfo.batteries.compartmentB.batteryCharging // In percentage
let currentVehiclePosition = motorInfo.postion.location 
```

This is how you can get the last 2 tracks and detail information about the last track:
```
let trackList = try await NiuAPI.tracks(forVehicleWith: scooterSerialNumber, take: 2, skip: 0, accessToken: accessToken)

let lastTrackId = trackList.last!.trackId
let lastTrackDate = trackList.last!.date
let detailsLastTrack = try await NiuAPI.detailTrack(forVehicleWith: scooterSerialNumber,
                                                    trackId: lastTrackId,
                                                    trackDate: lastTrackDate,
                                                    accessToken: accessToken)
```

You can also check the tests for further usage of the API or just explore this package yourself.


## Tests

The tests should cover all the API calls. You need to provide your `Account Infos` and `Access infos` to test all calls.
