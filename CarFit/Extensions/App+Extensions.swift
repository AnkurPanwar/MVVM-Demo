//
//  App+Extensions.swift
//  Calendar
//
//Test Project

import UIKit

//MARK:- Navigation bar clear
extension UINavigationBar {
    
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
}

extension Int{
    func getLastTwoDigits() -> Int?{
        let strInt = String(self)
        let lastTwoChars = strInt.suffix(2)
        return Int(lastTwoChars)
    }
    
    func getFirstTwoDigits() -> Int?{
        let strInt = String(self)
        let firstTwoChars = strInt.prefix(2)
        return Int(firstTwoChars)
    }
}

import CoreLocation
extension String
{
    func dateOnly() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFromString : Date = dateFormatter.date(from: self)!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: dateFromString)
    }
    
    func timeOnly() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFromString : Date = dateFormatter.date(from: self)!
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: dateFromString)
    }
    
    //if today's date is selected on calendar then we need to show "Today" title in header
    func isShowingTodayList() -> Bool
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFromString : String = dateFormatter.string(from: Date())
        
        print(dateFromString == self)
        return dateFromString == self
    }
    
    //get distance between two locations
    static func getDistance(lat1: Double, long1: Double, lat2: Double, long2: Double) -> String
    {
        
        let coordinate₀ = CLLocation(latitude: lat1, longitude: long1)
        let coordinate₁ = CLLocation(latitude: lat2, longitude: long2)

        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        return Double(round(100*(distanceInMeters/1000))/100).description
    }
}
