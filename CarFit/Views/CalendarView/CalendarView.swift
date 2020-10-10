//
//  CalendarView.swift
//  Calendar
//
//  Test Project
//

import UIKit

protocol CalendarDelegate: class {
    func getSelectedDate(_ date: [String])
}

class CalendarView: UIView {

    @IBOutlet weak var monthAndYear: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    
    let calendarHandler = CalendarHandler()
    
    private let cellID = "DayCell"
    weak var delegate: CalendarDelegate?

    //MARK:- Initialize calendar
    private func initialize() {
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.daysCollectionView.register(nib, forCellWithReuseIdentifier: self.cellID)
        self.daysCollectionView.delegate = self
        self.daysCollectionView.dataSource = self
        setMonthAndYear()
        
    }
    
    //MARK:- Change month when left and right arrow button tapped
    @IBAction func arrowTapped(_ sender: UIButton) {
        if sender == leftBtn
        {
            calendarHandler.changeMonth(next: false)
        }
        else
        {
            calendarHandler.changeMonth(next: true)
        }
        setMonthAndYear()
        daysCollectionView.reloadData()
        let selectedDays = calendarHandler.getSelectedDays()
        if selectedDays.count > 0
        {
            daysCollectionView.scrollToItem(at: IndexPath(row: selectedDays.first!.day - 1, section: 0), at: .left, animated: true)
        }
        else
        {
            daysCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        }
        
    }
    
    private func setMonthAndYear()
    {
        monthAndYear.text = calendarHandler.getMonthAndYear()
    }
}

//MARK:- Calendar collection view delegate and datasource methods
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarHandler.getDaysForGivenMonth()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! DayCell
        cell.prepareCell(calendarHandler.getDayDetailsForGivenMonth(for: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        calendarHandler.setSelectedDates(indexPath.row)
        delegate?.getSelectedDate(calendarHandler.selectedDates)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
}

//MARK:- Add calendar to the view
extension CalendarView {
    
    public class func addCalendar(_ superView: UIView) -> CalendarView? {
        var calendarView: CalendarView?
        if calendarView == nil {
            calendarView = UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: self, options: nil).last as? CalendarView
            guard let calenderView = calendarView else { return nil }
            calendarView?.frame = CGRect(x: 0, y: 0, width: superView.bounds.size.width, height: superView.bounds.size.height)
            superView.addSubview(calenderView)
            calenderView.initialize()
            return calenderView
        }
        return nil
    }
    
}
