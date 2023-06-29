//
//  TaskTableViewCell.swift
//  To Do
//
//  Created by Yessimkhan Zhumash on 21.06.2023.
//

import UIKit
import SnapKit

class TaskTableViewCell: UITableViewCell {
    
    static let identifier = "TaskTableViewCell"
    
    private let taskName: UILabel = {
        let label = UILabel()
        label.text = "vnfoanbvoan"
        label.font = Fonts.body
        label.textColor = Colors.bigTextColor
        label.numberOfLines = 0
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Functions
    
    func configure(name: String){
        self.taskName.text = name
    }

}


extension TaskTableViewCell {
    func setupViews(){
        contentView.addSubview(taskName)
    }
    func setupConstraints(){
        taskName.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(24)
            make.leading.trailing.equalToSuperview().inset(52)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
