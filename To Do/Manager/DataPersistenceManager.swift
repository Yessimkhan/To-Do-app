//
//  DataPersistenceManager.swift
//  To Do
//
//  Created by Yessimkhan Zhumash on 03.09.2023.
//


import Foundation
import UIKit
import CoreData

class DataPersistenceManager{
    
    enum DatabaseError: Error{
        case failedToSavedData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    func saveTask(model: Task, completion: @escaping(Result<Void, Error>)->Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = Tasks(context: context)
        item.name = model.name
        item.date = model.date
        item.isDone = model.isDone
        item.importance = Int16(model.improtance)
        
        do{
            try context.save()
            completion(.success(()))
            print("saved")
        }catch{
            completion(.failure(DatabaseError.failedToSavedData))
        }
    }
    
    
    
    func fetchingTasksFromDatabase(completion: @escaping (Result<[Tasks], Error >) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Tasks>
        request = Tasks.fetchRequest()
        do{
            let titles = try context.fetch(request)
            completion(.success(titles))
            
        }catch{
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteTaskWith(model: Tasks, completion: @escaping (Result<Void, Error >)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    func updateTaskWith(model: Tasks, completion: @escaping (Result<Void, Error >)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        model.isDone = true
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
}

