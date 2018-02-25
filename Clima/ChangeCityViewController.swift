//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit


//Write the protocol declaration here:
////////////////////////////////////////////////////////////
//////////////////// Creating protocols ////////////////////
////////////////////////////////////////////////////////////
// a protocol creation can be viewed as a contract creation.
// By creating this protocol I'm declaring that the delegate
// should be able to implement the method declared inside the
// protocol. (a protocol is similar to a abstract class in Java,
// where it gives me method signatures. However, I have to decide
// on how to declaire that method.)
protocol ChangeCityDelegate {
    func userEnterANewCityName(city : String)
}


class ChangeCityViewController: UIViewController {
    
    //Declare the delegate variable here:
    var delegate : ChangeCityDelegate?
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        
        //1 Get the city name the user entered in the text field
        let cityName = changeCityTextField.text!
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        
        // optional chaining -> it checks if a delegate has a value or is nill
        // if the delegate has a value the method is executed, else the line of
        // code is completely ignored. (alternative to optional binding)
        delegate?.userEnterANewCityName(city: cityName)
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        let cityName = changeCityTextField.text!
        delegate?.userEnterANewCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
    }
    
}
