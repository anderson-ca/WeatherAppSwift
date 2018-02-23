//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation // -> Module the allow me to use the GPS functionality of the iPhone
import Alamofire
import SwiftyJSON

// CLLocationManagerDelegate -> protocol for how my app will handle location data.
// Therefore, my class is a sub-class of the UIViewController super-class, and conforms
// to the rules delegated by the Core Location Manager Delegate.
class WeatherViewController: UIViewController, CLLocationManagerDelegate  {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "9c40c79c3221b61aefc819957814ade5"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        
        locationManager.delegate = self // -> this class has to become the delegate of the location manager.
        // The delegate is responsible for dealing with location data once it's retreived from the locationManager.
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // -> dictate the level of accuracy of
        // the data retrived by the location manager.
        
        locationManager.requestWhenInUseAuthorization() // -> request the user's autorization to use their location.
        
        locationManager.startUpdatingLocation() // -> kickstart the process where the location manager starts looking
        // for the location of the current iPhone(asynchronous method).
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String : String]) {
        
        // url -> the url to the api. the HTTP request(method) -> describes what I want to do with
        // the data being retrieved from the server. parameters -> these are the parameters specified
        // by the API documentation.
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            
            response in
            if response.result.isSuccess {
                print("got the weather data! NOICE!!!")
                
                // It is reasonably safe to use force unrwapping in this situation. Because, the force
                // unwrap is inside a if satement.
                let weatherJSON : JSON = JSON(response.result.value!)
                
                // call the method created. The method will receive the json object I reveived from the API call.
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                print("Error \(response.result.error)")
                self.cityLabel.text = "Connection Issues."
            }
        }
        
    }

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    
    // create method that will be called inside the get weather method. This method will revieve one paramete
    // of type JSON. Also, this method will access values inside the json object and asign these values to
    // variables.
    func updateWeatherData(json : JSON) {
        
        if let tempResult = json["main"]["temp"].double {
        
        weatherDataModel.temperature = Int(tempResult - 273.5)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        updateUIWithWeatherData()
            
        } else {
            cityLabel.text = "Weather unavailable"
        }
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    
    func updateUIWithWeatherData() {
    
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = String(weatherDataModel.temperature)
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    //Write the updateUIWithWeatherData method here:
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    
    //////////////////////////////////////////////////////////////
    // tells the delegate that new location value is available. //
    //////////////////////////////////////////////////////////////
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // in the array of CLLocation objects retrieve the element in the last index.
        // Because the last location retrieved is the most accurate one.
        let location = locations[locations.count - 1]
        
        // check the acccuracy of the retrieved location. The horizontal radius value
        // can't be below zero, therefore, a returned value of zero indicates an error.
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("longitude:  \(location.coordinate.longitude), latitude: \(location.coordinate.latitude)")
            
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            
            // dictionary -> an array of key value pairs. This is the argument that will be used in the url that
            // executes the API call to openWeather. Obs; key and values can have different datatypes.
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    //Write the didFailWithError method here:
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    // tells the delegate that the location manager was unable to retreive a location value. //
    ///////////////////////////////////////////////////////////////////////////////////////////
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable."
    }
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


