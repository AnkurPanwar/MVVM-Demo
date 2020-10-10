//
//  HomeTableViewCell.swift
//  Calendar
//
//  Test Project
//

import UIKit
import CoreLocation

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tasks: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var timeRequired: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    private var viewModel: TaskDataModel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10.0
        self.statusView.layer.cornerRadius = self.status.frame.height / 2.0
        self.statusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func prepareCell(viewModel: TaskDataModel) {
        self.viewModel = viewModel
        setUpUI()
    }
    
    private func setUpUI() {
        guard let viewModel = self.viewModel else { return }
        customer.text = viewModel.getCustomer()
        status.text = viewModel.visitState
        statusView.backgroundColor = viewModel.getTaskViewColor()
        tasks.text = viewModel.getTaskTitle()
        arrivalTime.text = viewModel.getStartTimeUtc()
        destination.text = viewModel.getAddress()
        timeRequired.text = viewModel.totalTime()
        distance.text = viewModel.getDistToCover()
        
    }

}
