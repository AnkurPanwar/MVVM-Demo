//
//  ViewController.swift
//  Calendar
//
//  Test Project
//

import UIKit

class HomeViewController: UIViewController, AlertDisplayer {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var calendarView: UIView!
    @IBOutlet weak var calendar: UIView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var workOrderTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private var homeViewModel: HomeViewModel = HomeViewModel()
    private let cellID = "HomeTableViewCell"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCalendar()
        self.setRefreshControl()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gestureTableView = UITapGestureRecognizer(target: self, action:  #selector (self.tableViewTapAction (_:)))
        self.workOrderTableView.addGestureRecognizer(gestureTableView)
        self.setupUI()
    }
    
    //MARK:- Handle refresh control action
    @objc private func refreshTaskList(_ sender: Any) {
        workOrderTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    private func setRefreshControl()
    {
        refreshControl.backgroundColor = .lightGray
        let font = UIFont.systemFont(ofSize: 14, weight: .light)
        let attributes = [NSAttributedString.Key.font: font]
        refreshControl.attributedTitle = NSAttributedString(string: "Updating Tasks...", attributes: attributes)
        if #available(iOS 10.0, *) {
            workOrderTableView.refreshControl = refreshControl
        } else {
            workOrderTableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshTaskList), for: .valueChanged)
    }
    
    //MARK:- Add calender to view
    private func addCalendar() {
        if let calendar = CalendarView.addCalendar(self.calendar) {
            calendar.delegate = self
            calendar.delegate?.getSelectedDate(calendar.calendarHandler.selectedDates)
        }
    }
    
    @objc func tableViewTapAction(_ sender:UITapGestureRecognizer){
        UIView.animate(withDuration: 0.5) {
            self.calendarView.transform = CGAffineTransform(translationX: 0, y: -200)
            self.workOrderTableView.transform = CGAffineTransform(translationX: 0, y: -112)
        }
    }

    //MARK:- UI setups
    private func setupUI() {
        self.navBar.transparentNavigationBar()
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.workOrderTableView.register(nib, forCellReuseIdentifier: self.cellID)
        self.workOrderTableView.rowHeight = UITableView.automaticDimension
        self.workOrderTableView.estimatedRowHeight = 170
    }
    
    //MARK:- Show calendar when tapped, Hide the calendar when tapped outside the calendar view
    @IBAction func calendarTapped(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.5) {
            self.calendarView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.workOrderTableView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
}


//MARK:- Tableview delegate and datasource methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.tasksDetailModel?.filteredData?.count ?? 0
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! HomeTableViewCell
        cell.prepareCell(viewModel: (homeViewModel.tasksDetailModel?.filteredData?[indexPath.row])!)
        return cell
    }
    
}
//MARK:- Get selected calendar date
extension HomeViewController: CalendarDelegate {
    func getSelectedDate(_ date: [String]) {
        //filter data in tableview
        let filteredDataArray = homeViewModel.filterDataForListing(date)
        
        homeViewModel.tasksDetailModel?.filteredData = filteredDataArray
        self.navBar.topItem?.title =  self.homeViewModel.getHeaderTitle(date)
        
        workOrderTableView.reloadData()
    }
}
