//
//  DateTableViewCell.swift
//  To Do
//
//  Created by Yessimkhan Zhumash on 07.07.2023.
//

import UIKit
import SnapKit

protocol DateTableViewCellDelegate: AnyObject {
    func switchButtonTapped(_ cell: DateTableViewCell)
}

class DateTableViewCell: UITableViewCell {
    static let identifier = "DateTableViewCell"
    static var withDeadline: Bool = false
    weak var delegate: DateTableViewCellDelegate?
    
    let bigLabel: UILabel = {
        let label = UILabel()
        label.text = "Deadline"
        label.font = Fonts.body
        label.textColor = Colors.bigTextColor
        return label
    }()
    static let deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "2 июня 2021"
        label.font = Fonts.footnote
        label.textColor = Colors.blue
        label.isHidden = true
        return label
    }()
    
    let switchButton: UISwitch = {
        let button = UISwitch()
        button.addTarget(self, action: #selector(switchButtonTapped), for: .valueChanged)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func switchButtonTapped() {
        if !DateTableViewCell.withDeadline {
            bigLabel.snp.updateConstraints { make in
                make.top.equalToSuperview().inset(8)
            }
        }else{
            bigLabel.snp.updateConstraints { make in
                make.top.equalToSuperview().inset(17)
            }
        }
        DateTableViewCell.withDeadline.toggle()
        delegate?.switchButtonTapped(self)
        DateTableViewCell.deadlineLabel.isHidden.toggle()
    }
    
}

extension DateTableViewCell {
    func setupViews(){
        contentView.addSubview(bigLabel)
        contentView.addSubview(DateTableViewCell.deadlineLabel)
        contentView.addSubview(switchButton)
    }
    func setupConstraints(){
        bigLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(17)
            make.height.equalTo(22)
        }
        DateTableViewCell.deadlineLabel.snp.makeConstraints { make in
            make.top.equalTo(bigLabel.snp.bottom)
            make.leading.equalTo(bigLabel.snp.leading)
            make.height.equalTo(18)
        }
        switchButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
