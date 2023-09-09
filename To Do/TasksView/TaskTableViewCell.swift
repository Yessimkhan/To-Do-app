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
    
    let taskDoneChecker: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "notDone")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = Colors.smallTextColor
        return imageView
    }()
    
    private let taskName: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Fonts.body
        label.textColor = Colors.bigTextColor
        label.numberOfLines = 0
        return label
    }()
    let arrowRight: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "arrowRight")
        imageView.image = image
        return imageView
    }()
    let calendarImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "Calendar")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = Colors.smallTextColor
        return imageView
    }()
    private let taskData: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Fonts.subhead
        label.textColor = Colors.smallTextColor
        label.numberOfLines = 0
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Functions
    
    func configure(data: Tasks){
        
        
        if let d = data.date {
            calendarImageView.isHidden = false
            taskData.isHidden = false
            taskData.snp.updateConstraints { make in
                make.height.equalTo(20)
            }
            taskName.snp.updateConstraints { make in
                make.height.greaterThanOrEqualTo(24)
            }
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: d)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let monthName = dateFormatter.monthSymbols[(dateComponents.month ?? 1) - 1]
            taskData.text = "\(dateComponents.day ?? 0) \(monthName)"
        }else{
            taskData.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            taskName.snp.updateConstraints { make in
                make.height.greaterThanOrEqualTo(32)
            }
            calendarImageView.isHidden = true
            taskData.isHidden = true
        }
        
        
        if data.importance != 1 {
            let textWithImage = NSMutableAttributedString()
            let imageAttachment = NSTextAttachment()
            if data.importance == 0 {
                imageAttachment.image = UIImage(named: "ArrowDown")
            } else {
                imageAttachment.image = UIImage(named: "Priority")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            }
            // Create an attributed string with the image
            let imageString = NSAttributedString(attachment: imageAttachment)
            textWithImage.append(imageString)
            if let text = data.name {
                textWithImage.append(NSAttributedString(string: " \(text)"))
            }

            // Assign the attributed string to your UILabel or UITextView
            taskName.attributedText = textWithImage
        }else {
            taskName.text = data.name
        }
        
        if data.isDone == true {
            configureDone()
        }else{
            taskDoneChecker.image = UIImage(named: "notDone")?.withRenderingMode(.alwaysTemplate)
        }
    }
    func configureDone(){
        print("\(taskName.text) configureDone")
        self.taskDoneChecker.image = UIImage(named: "doneGreen")
        self.taskName.attributedText = NSAttributedString(string: self.taskName.attributedText?.string ?? "", attributes: [ NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue ])
        self.taskName.textColor = Colors.smallTextColor
        
    }
    
}


extension TaskTableViewCell {
    func setupViews(){
        contentView.addSubview(taskDoneChecker)
        contentView.addSubview(arrowRight)
        contentView.addSubview(taskName)
        contentView.addSubview(calendarImageView)
        contentView.addSubview(taskData)
    }
    func setupConstraints(){
        taskDoneChecker.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        arrowRight.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        taskName.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(24)
            make.leading.equalTo(taskDoneChecker.snp.trailing).inset(-12)
            make.trailing.equalTo(arrowRight.snp.leading).inset(-16)
        }
        calendarImageView.snp.makeConstraints { make in
            make.centerY.equalTo(taskData.snp.centerY)
            make.leading.equalTo(taskName.snp.leading)
        }
        taskData.snp.makeConstraints { make in
            make.top.equalTo(taskName.snp.bottom)
            make.leading.equalTo(calendarImageView.snp.trailing).inset(-2)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
