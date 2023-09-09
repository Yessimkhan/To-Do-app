//
//  NewTaskViewController.swift
//  To Do
//
//  Created by Yessimkhan Zhumash on 29.06.2023.
//

import UIKit
import SnapKit

class NewTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    private var tasks: [Tasks] = [Tasks]()
    public static var importance = 1
    public static var date: Date?
    
    let taskNameView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 16
        textView.font = Fonts.body
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        textView.backgroundColor = Colors.cellsColor
        return textView
    }()
    let placeholder: UILabel = {
        let label = UILabel()
        label.textColor = Colors.smallTextColor
        label.text = "Что надо сделать?"
        return label
    }()
    var rows = 2
    let tableView: ContentSizedTableView = {
        let tableView = ContentSizedTableView()
        tableView.layer.cornerRadius = 16
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.clipsToBounds = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backroundColor
        navigationItem.title = "Дело"
        taskNameView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sizeToFit()
        tableView.register(ImportanceTableViewCell.self, forCellReuseIdentifier:  ImportanceTableViewCell.identifier)
        tableView.register(DateTableViewCell.self, forCellReuseIdentifier:  DateTableViewCell.identifier)
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier:  CalendarTableViewCell.identifier)
        
        // Create and set the left bar button item
        let cancelButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        navigationItem.leftBarButtonItem = cancelButton
        
        // Create and set the right bar button item
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        setupViews()
        setupConstraints()
    }
    
    private func downloadTitleAt(task: Task){
        DataPersistenceManager.shared.saveTask(model: task) { result in
            switch result{
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholder.isHidden = !textView.text.isEmpty
    }
    
    @objc func cancelButtonTapped() {
        dismissNewTaskView()
    }
    func dismissNewTaskView(){
        NewTaskViewController.importance = 1
        NewTaskViewController.date = nil
        DateTableViewCell.withDeadline = false
        DateTableViewCell.deadlineLabel.isHidden = true
        self.dismiss(animated: true)
    }
    @objc func saveButtonTapped() {
        if let name = taskNameView.text, !name.isEmpty {
            let task = Task(name: name, improtance: NewTaskViewController.importance, date: NewTaskViewController.date ?? nil, isDone: false)
            print(task)
            self.downloadTitleAt(task: task)
            dismissNewTaskView()
        } else {
            print("Where is the name?")
        }
    }

    
    
}

extension NewTaskViewController {
    
    func setupViews(){
        view.addSubview(taskNameView)
        view.addSubview(placeholder)
        view.addSubview(tableView)
    }
    
    func setupConstraints(){
        taskNameView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(72)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(120)
            //            make.height.lessThanOrEqualTo(484)
        }
        placeholder.snp.makeConstraints { make in
            make.top.equalTo(taskNameView.snp.top).offset(12)
            make.leading.equalTo(taskNameView.snp.leading).inset(21)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(taskNameView.snp.bottom).inset(-16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(112)
        }
    }
}
extension NewTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImportanceTableViewCell.identifier, for: indexPath) as? ImportanceTableViewCell else {
                fatalError("Failed to dequeue ImportanceTableViewCell")
            }
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.identifier, for: indexPath) as? DateTableViewCell else {
                fatalError("Failed to dequeue DateTableViewCell")
            }
            if rows == 2{
                cell.separator(hide: true)
            }
            cell.delegate = self
            return cell
        } else if indexPath.row == 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as? CalendarTableViewCell else {
                fatalError("Failed to dequeue ImportanceTableViewCell")
            }
            return cell
        }
        return UITableViewCell()
    }
    
}

extension NewTaskViewController: DateTableViewCellDelegate {
    func switchButtonTapped(_ cell: DateTableViewCell) {
        if DateTableViewCell.withDeadline {
            rows = 3
            tableView.snp.updateConstraints { make in
                make.height.equalTo(444)
            }
            tableView.reloadData()
            print("hello")
        }
        else{
            tableView.snp.updateConstraints { make in
                make.height.equalTo(112)
            }
            print("bye bye")
        }
    }
}
