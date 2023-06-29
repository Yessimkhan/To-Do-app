//
//  ViewController.swift
//  To Do
//
//  Created by Yessimkhan Zhumash on 20.06.2023.
//

import UIKit
import SnapKit

extension UITableViewCell {
    func separator(hide: Bool) {
        separatorInset.left = hide ? bounds.size.width : 0
    }
}

class ViewController: UIViewController {
    
    weak var tableViewHeightConstraint: NSLayoutConstraint?
    
    var tasks = ["Задание 1", "Задание 2 Задание 2 Задание 2 Задание 2 Задание 2 Задание 2 Задание 2 Задание 2 Задание 2 Задание 2 Задание 2 Задание 2 Задание 2 Задание 2 Задание 2 Задание 2 Задание 2", "Задание 3", "Задание 3", "Задание 3", "Задание 3", "Задание 3", "Задание 3", "Задание 3", "Задание 3", "Задание 3", "Задание 3", "Задание 3", "Задание 3", "Задание 3", "Задание 3", "Задание 3", "Задание 3", "Задание 3", "Задание 3", "Задание 3"]
    
    let smallTitle: UILabel = {
        let label = UILabel()
        label.text = "Выполнено — 5"
        label.font = Fonts.subhead
        label.textColor = Colors.smallTextColor
        return label
    }()
    
    let showLabel: UILabel = {
        let label = UILabel()
        label.text = "Показать"
        label.font = Fonts.subHeadline
        label.textColor = Colors.blue
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let taskTableView: ContentSizedTableView = {
        let tableView = ContentSizedTableView()
        tableView.backgroundColor = UIColor(hex: "F7F6F2")
        tableView.bounces = false
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        
        return tableView
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "plus")
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = Colors.backroundColor
        
        self.title = "Мой дела"
        navigationController?.navigationBar.prefersLargeTitles = true
        if let navigationController = self.navigationController {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .right
            paragraphStyle.firstLineHeadIndent = 16
            
            navigationController.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        }
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(TaskTableViewCell.self, forCellReuseIdentifier:  TaskTableViewCell.identifier)
        
        setupViews()
        setupConstraints()
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = taskTableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
            fatalError("Failed to dequeue CharacterTableViewCell")
        }
        cell.configure(name: tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completion) in
            // Perform the delete logic here
            self.deleteCell(at: indexPath)
            
            completion(true)
        }
        
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(named: "delete")
        
        let infoAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completion) in
            // Perform the delete logic here
            print("tapped info")
            
            completion(true)
        }
        
        infoAction.backgroundColor = UIColor(hex: "D1D1D6")
        infoAction.image = UIImage(named: "info")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
        configuration.performsFirstActionWithFullSwipe = false // Disable full swipe behavior
        
        return configuration
    }
    func deleteCell(at indexPath: IndexPath) {
        // Perform the deletion from your data source
        // For example, if you have an array of items:
        tasks.remove(at: indexPath.row)
        
        // Then, update the table view
        taskTableView.deleteRows(at: [indexPath], with: .fade)

    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            // Perform the color change logic here
            self.changeColorForCell(at: indexPath)
            
            completion(true)
        }
        
        doneAction.backgroundColor = UIColor.green // Set the desired color
        doneAction.image = UIImage(named: "done")
        
        let configuration = UISwipeActionsConfiguration(actions: [doneAction])
        configuration.performsFirstActionWithFullSwipe = false // Disable full swipe behavior
        
        return configuration
    }
    
    func changeColorForCell(at indexPath: IndexPath) {
        if let cell = taskTableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.green // Set the desired color for the cell
        }
    }
    
    
}


// MARK: - Setup views and constraints
extension ViewController{
    func setupViews(){
        scrollView.addSubview(smallTitle)
        scrollView.addSubview(showLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(taskTableView)
        view.addSubview(plusButton)
    }
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        taskTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.leading.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        smallTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        showLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        plusButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(54)
            make.centerX.equalToSuperview()
        }
    }
}

