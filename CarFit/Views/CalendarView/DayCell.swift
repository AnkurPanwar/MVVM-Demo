//
//  DayCell.swift
//  Calendar
//
//  Test Project
//

import UIKit

class DayCell: UICollectionViewCell {

    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weekday: UILabel!
    private var viewModel: DayModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dayView.layer.cornerRadius = self.dayView.frame.width / 2.0
        self.dayView.backgroundColor = .clear
    }
    
    func prepareCell(_ viewModel: DayModel) {
        self.viewModel = viewModel
        setUpUI()
    }

    private func setUpUI() {
        guard let vwModel = self.viewModel else { return }
        day.text = vwModel.day.description
        weekday.text = vwModel.weekDay
        if (vwModel.isSelected)
        {
            dayView.backgroundColor = .daySelected
        }
        else
        {
            dayView.backgroundColor = .clear
        }

    }
}
