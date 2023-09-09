//
//  TableViewCell.swift
//  To Do
//
//  Created by Yessimkhan Zhumash on 07.07.2023.
//

import UIKit

class ImportanceTableViewCell: UITableViewCell {
    
    static let identifier = "ImportanceTableViewCell"
    
    let importanceLabel: UILabel = {
       let label = UILabel()
        label.text = "Importance"
        label.font = Fonts.body
        label.textColor = Colors.bigTextColor
        return label
    }()
    let items = ["low", "no", "high"]
    lazy var importanceSegment: UISegmentedControl = {
       let segment = UISegmentedControl(items: items)
        segment.setTitleTextAttributes([NSAttributedString.Key.font: Fonts.subhead], for: .normal)
        segment.setImage(UIImage(named: "ArrowDown"), forSegmentAt: 0)
        let image = UIImage(named: "Priority")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        segment.setImage(image, forSegmentAt: 2)
        segment.selectedSegmentIndex = 1
        segment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return segment
        
    }()

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        // Get the selected segment index
        let selectedSegmentIndex = sender.selectedSegmentIndex
        
        // Do something with the selected segment index
        print("Selected segment index: \(selectedSegmentIndex)")
        NewTaskViewController.importance = selectedSegmentIndex
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ImportanceTableViewCell {
    func setupViews(){
        contentView.addSubview(importanceLabel)
        contentView.addSubview(importanceSegment)
    }
    func setupConstraints(){
        importanceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalTo(importanceSegment.snp.centerY)
            make.height.equalTo(20)
        }
        importanceSegment.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(36)
            make.width.equalTo(147)
        }
    }
}

