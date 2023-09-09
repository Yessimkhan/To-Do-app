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
    private var tasks = [Tasks]()
    let smallTitle: UILabel = {
        let label = UILabel()
        label.text = "Выполнено — 5"
        label.font = Fonts.subhead
        label.textColor = Colors.smallTextColor
        return label
    }()
    
    let showLabel: UIButton = {
        let label = UIButton()
        label.setTitle("reload", for: .normal)
//        label.font = Fonts.subHeadline!
        label.setTitleColor(Colors.blue, for: .normal)
        label.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
        return label
    }()
    
    @objc func reloadButtonTapped(){
        taskTableView.reloadData()
    }
    
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let taskTableView: ContentSizedTableView = {
        let tableView = ContentSizedTableView()
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "plus")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func plusButtonTapped(){
        let newTaskViewController = NewTaskViewController()
        let navigationController = UINavigationController(rootViewController: newTaskViewController)
        present(navigationController, animated: true, completion: nil)

    }
    
    
    
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
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
        setupViews()
        setupConstraints()
        
    }
    private func fetchLocalStorageForDownload(){
        DataPersistenceManager.shared.fetchingTasksFromDatabase { [weak self] result in
            switch result{
            case .success(let tasks):
                self?.tasks = tasks
                DispatchQueue.main.async {
                    self?.taskTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
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
        
        cell.configure(data: self.tasks[indexPath.row])
        
        cell.backgroundColor = Colors.cellsColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [self] (action, view, completion) in
            DataPersistenceManager.shared.deleteTaskWith(model: tasks[indexPath.row]) { [weak self]
                result in
                switch result{
                case.success:
                    print("Deleted")
                case.failure(let error):
                    print(error.localizedDescription)
                }
                self?.tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            completion(true)
        }
        
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(named: "delete")
        
        let infoAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completion) in
            print("tapped info")
            
            completion(true)
        }
        
        infoAction.backgroundColor = UIColor(hex: "D1D1D6")
        infoAction.image = UIImage(named: "info")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            // Perform the color change logic here
            self.changeDoneColorForCell(at: indexPath)
            DataPersistenceManager.shared.updateTaskWith(model: self.tasks[indexPath.row]) { [weak self]
                result in
                switch result{
                case.success:
                    print("done task")
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            completion(true)
        }
        
        doneAction.backgroundColor = UIColor.green // Set the desired color
        doneAction.image = UIImage(named: "done")
        
        let configuration = UISwipeActionsConfiguration(actions: [doneAction])
        configuration.performsFirstActionWithFullSwipe = false // Disable full swipe behavior
        
        return configuration
    }
    
    func changeDoneColorForCell(at indexPath: IndexPath) {
        if let cell = taskTableView.cellForRow(at: indexPath) as? TaskTableViewCell {
            cell.configureDone()
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
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
    }
}

