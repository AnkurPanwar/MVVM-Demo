//
//  TaskDetailModel.swift
//  CarFit
//
//  Created by Ankur on 01/08/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
import UIKit

struct TaskDetailModel: Codable
{
    var success: Bool
    var message: String
    var data: [TaskDataModel]
    var filteredData: [TaskDataModel]? = []
    var code: Int
    
    mutating func setAdjacentVisitDistance()
    {
        //assuming array is sorted in increasing order of date and time
        for index in 0..<data.count
        {
            if index < data.count - 1
            {
                data[index].adjacentDistance = String.getDistance(lat1: data[index].houseOwnerLatitude, long1: data[index].houseOwnerLongitude, lat2: data[index+1].houseOwnerLatitude, long2: data[index+1].houseOwnerLongitude)
            }
        }
    }
}

struct TaskDataModel: Codable
{
    var visitId: String
    var homeBobEmployeeId: String
    var houseOwnerId: String
    var isBlocked: Bool
    var startTimeUtc: String
    var endTimeUtc: String
    var title: String
    var isReviewed: Bool
    var isFirstVisit: Bool
    var isManual: Bool
    var visitTimeUsed: Int
    var rememberToday: Bool?
    var houseOwnerFirstName: String
    var houseOwnerLastName: String
    var houseOwnerMobilePhone: String
    var houseOwnerAddress: String
    var houseOwnerZip: String
    var houseOwnerCity: String
    var houseOwnerLatitude: Double
    var houseOwnerLongitude: Double
    var isSubscriber: Bool
    var rememberAlways: Bool?
    var professional: String
    var visitState: String
    var stateOrder: Int
    var expectedTime: String?
    var houseOwnerAssets: [String]?
    var visitAssets: [String]?
    var visitMessages: [String]?
    var adjacentDistance: String?
    
    var tasks: [TasksModel]
    
    func getCustomer() -> String
    {
        return houseOwnerFirstName + " " + houseOwnerLastName
    }
    
    func getStartTimeUtc() -> String
    {
        return startTimeUtc.timeOnly()
    }

    func getAddress() -> String
    {
        return houseOwnerAddress + " " + houseOwnerZip + " " + houseOwnerCity
    }
    
    func getDistToCover() -> String
    {
        if isFirstVisit
        {
            return "O Km"
        }
        else
        {
            return (adjacentDistance  ?? "0") + " Km"
        }
    }
    
    func getTaskTitle() -> String
    {
        self.tasks.map{$0.title}.joined(separator: ",")
    }
    
    func totalTime() -> String
    {
        let totlTime = self.tasks.reduce(0) { (result, taskModel) -> Int in
            result + taskModel.timesInMinutes
        }
        return totlTime.description
    }
    
    func getTaskViewColor() -> UIColor
    {
        switch stateOrder {
        case 1:
            return UIColor.doneOption
        case 2:
            return UIColor.todoOption
        case 3:
            return UIColor.inProgressOption
        case 4:
            return UIColor.rejectedOption
            
        default:
            return UIColor.todoOption
        }
    }
}

struct TasksModel: Codable
{
    var taskId: String
    var title: String
    var isTemplate: Bool
    var timesInMinutes: Int
    var price: Float
    var paymentTypeId: String
    var createDateUtc: String
    var lastUpdateDateUtc: String
    var paymentTypes: String?
}
