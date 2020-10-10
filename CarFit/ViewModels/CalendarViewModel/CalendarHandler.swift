//
//  CalendarHandler.swift
//  CarFit
//
//  Created by Ankur on 01/08/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

enum Days: String,CaseIterable {
    case sunday = "Sun"
    case monday = "Mon"
    case tuesday = "Tue"
    case wednesday = "Wed"
    case thursday = "Thu"
    case friday = "Fri"
    case saturday = "Sat"
    static func getDays() -> [Days]{
        return Days.allCases
    }
}

enum Months: String, CaseIterable {
    case january = "Jan"
    case february = "Feb"
    case march = "Mar"
    case april = "Apr"
    case may = "May"
    case june = "Jun"
    case july = "Jul"
    case august = "Aug"
    case september = "Sep"
    case october = "Oct"
    case november = "Nov"
    case december = "Dec"
    static func getMonths() -> [Months]{
        return Months.allCases
    }
}

class CalendarHandler
{
    private var yearsArr: [YearModel] = []
    private (set) var selectedDates: [String] = []
    private var currentInDisplayYearIndex: Int = -1 //Index of year that is displaying on screen
    private var currentInDisplayMonthIndex: Int = -1  //Index of month that is displaying on screen
    private var currentInDisplayDayIndex: Int = -1  //Index of day that is displaying on screen
    
    init()
    {
        yearsArr.append(YearModel(Calendar.current.component(.year, from: Date())))
        setAllIndeces()
        setSelectedDates(currentInDisplayDayIndex)
    }
    
//    MARK:- Logic for changing months back and forth
    func changeMonth(next: Bool)
    {
        if (next)
        {
            if (currentInDisplayMonthIndex == 11)
            {
                addYear(yearsArr[currentInDisplayYearIndex].year + 1)
                currentInDisplayYearIndex = currentInDisplayYearIndex + 1
                currentInDisplayMonthIndex = 0
                currentInDisplayDayIndex = 0
            }
            else
            {
                currentInDisplayMonthIndex = currentInDisplayMonthIndex + 1
                currentInDisplayDayIndex = 0
            }
        }
        else
        {
            if (currentInDisplayMonthIndex == 0)
            {
                addYear(yearsArr[currentInDisplayYearIndex].year - 1)
                currentInDisplayYearIndex = currentInDisplayYearIndex - 1
                currentInDisplayMonthIndex = 11
                currentInDisplayDayIndex = 0
            }
            else
            {
                currentInDisplayMonthIndex = currentInDisplayMonthIndex - 1
                currentInDisplayDayIndex = 0
            }
        }
    }
    
//  MARK:- when year is changed this func is called to add new year to array
    private func addYear(_ year: Int)
    {
        if (yearsArr.contains { (yearModel) -> Bool in
            yearModel.year == year
        })
        {
            return
        }
        
        yearsArr.append(YearModel(year))
    }
    
//    setting all indeces to default date(current date)
    func setAllIndeces(for date: Date = Date())
    {
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        
        let yearIndex = yearsArr.firstIndex { (yearModel) -> Bool in
            yearModel.year == year
        }
        
        let monthIndex = yearsArr[yearIndex!].MonthsArr.firstIndex { (monthModel) -> Bool in
            monthModel.month == month
        }
        
        let dayIndex = yearsArr[yearIndex!].MonthsArr[monthIndex!].days.firstIndex { (dayModel) -> Bool in
            dayModel.day == day
        }
        
        currentInDisplayYearIndex = yearIndex!
        currentInDisplayMonthIndex = monthIndex!
        currentInDisplayDayIndex = dayIndex!
    }

    func removeYear(_ yr: Int)
    {
        let index = yearsArr.firstIndex { (yearModel) -> Bool in
            yearModel.year == yr
        }
        if let indx = index
        {
            yearsArr.remove(at: indx)
        }
    }
    
//    MARK:- Selection Logic
//    For now user can select maximum of two values, we need to change constant value(2) to desired number to select more dates
    func setSelectedDates(_ dayIndexToToggle: Int)
    {
        //yyyy-mm-dd
        //get all selected dates
        if yearsArr[currentInDisplayYearIndex].MonthsArr[currentInDisplayMonthIndex].days[dayIndexToToggle].isSelected == false //means new selection
        {
            if selectedDates.count >= 2
            {
                //deselect prvious all dates, then select new date, As we need max of two selections
                for year in yearsArr
                {
                    for month in year.MonthsArr
                    {
                        for day in month.days
                        {
                            day.deselectDay()
                        }
                    }
                }
            }
        }
        
        yearsArr[currentInDisplayYearIndex].MonthsArr[currentInDisplayMonthIndex].days[dayIndexToToggle].toggleSelection()

        var fullDate: String = ""
        selectedDates = []
        for year in yearsArr
        {
            for month in year.MonthsArr
            {
                for day in month.days
                {
                    if (day.isSelected)
                    {
                        fullDate = year.year.description + "-" + String(format: "%02d", month.month) + "-" + String(format: "%02d", day.day)
                        selectedDates.append(fullDate)
                    }
                }
            }
        }
    }
    
    func getMonthAndYear() -> String
    {
        return yearsArr[currentInDisplayYearIndex].MonthsArr[currentInDisplayMonthIndex].monthName + " " +
            yearsArr[currentInDisplayYearIndex].year.description
    }
    
    func getSelectedDays() -> [DayModel]
    {
        let selectedDys = yearsArr[currentInDisplayYearIndex].MonthsArr[currentInDisplayMonthIndex].days.filter { (dayModel) -> Bool in
            dayModel.isSelected
        }
        
        return selectedDys 
    }
    
    func getDaysForGivenMonth() -> Int
    {
        return self.yearsArr[currentInDisplayYearIndex].MonthsArr[currentInDisplayMonthIndex].days.count
    }
    
    func getDayDetailsForGivenMonth(for day: Int) -> DayModel
    {
        return (self.yearsArr[currentInDisplayYearIndex].MonthsArr[currentInDisplayMonthIndex].days[day])
    }
}

class YearModel
{
    var year: Int
    var MonthsArr: [MonthModel] = []
    var isLeapYear: Bool
    
    
    init(_ yr: Int)
    {
        year = yr
        isLeapYear = YearModel.isYearLeapYear(yr)
        for monthVal in 1...12
        {
            MonthsArr.append(MonthModel.init(monthVal, isLeapYear, yr))
        }
    }
    
    private class func isYearLeapYear(_ yr: Int) -> Bool{
        if yr.getLastTwoDigits() == 00{
            return (yr % 100 == 0 && yr % 400 == 0) ?  true :  false
        }else{
            return yr % 4 == 0
        }
    }
}

class MonthModel
{
    var month: Int
    var monthName: String
    var days: [DayModel] = []
    
    init(_ mnth: Int,_ isLeapYear: Bool,_ year: Int)
    {
        month = mnth
        monthName = Months.getMonths()[month-1].rawValue
        var totalDaysInMonth = 0
        if (isLeapYear)
        {
            //set feb as 29 days
            totalDaysInMonth = 29
        }
        else
        {
            if (month == 2)
            {
                totalDaysInMonth = 28
            }
            else if (month == 4 || month == 6 || month == 9 || month == 11)
            {
                totalDaysInMonth = 30
            }
            else
            {
                totalDaysInMonth = 31
            }
        }
        
        for index in 1...totalDaysInMonth
        {
            let extractedDay = zellersFormula(forTheYear: year, index,mnth)
            days.append(DayModel(index, extractedDay.0, extractedDay.1))
        }
    }
    
    //F = K + [(13xM – 1)/5] + D + [D/4] + [C/4] – 2C
    private func zellersFormula(forTheYear year:Int,_ forDay: Int,_ mnth: Int) -> (Days, Int)
    {
        var D = year.getLastTwoDigits()
        if (mnth == 1 || mnth == 2)
        {
            D = (year - 1).getLastTwoDigits()
        }
        let C = year.getFirstTwoDigits()
        let F = (forDay + ((13*getZellersMonth(mnth) - 1)/5))
        let F2 = F +  D! + (D!/4)
        let F3 = F2 +  (C!/4) - (2*C!)
        var day = F3 % 7
        if day < 0{
            day = day + 7
        }
        return (Days.getDays()[day], day)
    }
    
    private func getZellersMonth(_ mnth: Int) -> Int
    {
        return (mnth+10)%12 == 0 ? 12 : (mnth+10)%12
    }
}

class DayModel
{
    var day: Int
    var weekDay: String
    var weekDayInt: Int
    var isSelected: Bool = false
    init(_ dy: Int,_ wkDy: Days,_ wkDyInt: Int)
    {
        day = dy
        weekDay = Days.getDays()[wkDyInt].rawValue
        weekDayInt = wkDyInt
    }
    
    func toggleSelection()
    {
        isSelected = !isSelected
    }
    
    func deselectDay()
    {
        isSelected = false
    }
}
