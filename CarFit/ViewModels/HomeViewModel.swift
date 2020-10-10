//
//  HomeViewModel.swift
//  CarFit
//
//  Created by Ankur on 02/08/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

class HomeViewModel
{
    //variable to store data from API
    var tasksDetailModel: TaskDetailModel? = nil

    init()
    {
        getAPIdata()
    }
    
//  MARK:- parsing resposne
    public func getAPIdata()
    {
        if let path = Bundle.main.path(forResource: "carfit", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                tasksDetailModel = try! JSONDecoder().decode(TaskDetailModel.self, from: data)
                
            } catch {
                
            }
            tasksDetailModel?.setAdjacentVisitDistance()
        }
    }
//  MARK:- Header Title
    public func getHeaderTitle(_ dates: [String]) -> String
    {
        if dates.count == 1 && dates.first!.isShowingTodayList()
        {
            return "Today"
        }
        else
        {
            return dates.map{$0}.joined(separator: ",")
        }
    }
    
//   filtered list contains data that is to be shown on listing
    public func filterDataForListing(_ date: [String]) -> [TaskDataModel]
    {
        return self.tasksDetailModel?.data.filter({ (data) -> Bool in
                   date.contains(data.startTimeUtc.dateOnly())
        }) ?? []
    }
}
