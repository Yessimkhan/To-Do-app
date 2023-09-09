//
//  CalendarTableViewCell.swift
//  To Do
//
//  Created by Yessimkhan Zhumash on 07.07.2023.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    static let identifier = "CalendarTableViewCell"
    
    let calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        var gregorianCalendar = Calendar(identifier: .gregorian)
        calendarView.calendar = gregorianCalendar
        calendarView.availableDateRange = DateInterval(start: .now, end: .distantFuture)
        calendarView.backgroundColor = .clear
        return calendarView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarTableViewCell {
    func setupViews(){
        contentView.addSubview(calendarView)
    }
    func setupConstraints(){
        calendarView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(332)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}



extension CalendarTableViewCell: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if var d = dateComponents {
            d.day = d.day!+1
            NewTaskViewController.date = Calendar.current.date(from: d)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let monthName = dateFormatter.monthSymbols[(dateComponents?.month ?? 1) - 1]
        DateTableViewCell.deadlineLabel.text = "\(dateComponents?.day ?? 0) \(monthName) \(dateComponents?.year ?? 0)"
    }
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
    
    
}

