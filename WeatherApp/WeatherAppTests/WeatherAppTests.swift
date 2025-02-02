//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Rosh on 31/01/25.
//

// WeatherAppTests.swift

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    // Your OpenWeatherMap API key
    let apiKey = "57e85b6fcf808b3c51dc9336a1f9e277"
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    
    // Mumbai's lat and lon
    let latitude: Double = 19.017615
    let longitude: Double = 72.856164
    
    // The URL to the OpenWeatherMap API
    var url: URL!
    
    override func setUpWithError() throws {
        super.setUp()
        
      
    url = URL(string: "\(baseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric")
        
       
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    func testFetchWeatherAPI() throws {
        // Create an expectation for the API call
        let expectation = self.expectation(description: "Weather Data Loaded")
        
        // Create a data task to fetch weather data from the API
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Ensure there are no errors
            XCTAssertNil(error, "Error occurred: \(error!.localizedDescription)")
            
            // Ensure we got data
            XCTAssertNotNil(data, "No data was returned by the API")
            
            // Try to parse the response data (JSON)
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                
                // Make assertions to validate the response
                XCTAssertEqual(weatherData.name, "Mumbai", "City name should be Mumbai")
                XCTAssertTrue(weatherData.main.temp > 0, "Temperature should be a valid number")
                
                // Fulfill the expectation when the test completes
                expectation.fulfill()
                
            } catch {
                // If parsing fails, fail the test
                XCTFail("Failed to decode JSON response: \(error.localizedDescription)")
            }
        }
        
        // Start the network request
        task.resume()
        
        // Wait for the API call to finish
        wait(for: [expectation], timeout: 60.0)
    }
}

