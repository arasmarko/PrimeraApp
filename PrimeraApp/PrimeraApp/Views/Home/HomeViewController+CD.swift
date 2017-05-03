//
//  HomeViewController+CD.swift
//  PrimeraApp
//
//  Created by Marko Aras on 03/05/2017.
//  Copyright © 2017 fer. All rights reserved.
//
import CoreData
import UIKit
import Foundation

extension HomeViewController {
    
    func loadFromCD() {
        
        let freq = NSFetchRequest<Query>(entityName: "Query")
        freq.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController<Query>(
            fetchRequest: freq,
            managedObjectContext: (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
        fetchedResultsController?.delegate = self
        
        
        do {
            try self.fetchedResultsController?.performFetch() 
            renderRecentSearches(terms: self.fetchedResultsController?.sections?[0].objects ?? [])
        } catch let err {
            print(err)
        }
        
        //getting data from API
        //delete from core data
        //                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        //                let managedContext = appDelegate.persistentContainer.viewContext
        //                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Query")
        //                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        //
        //                do {
        //                    print("deleted")
        //                    try managedContext.execute(deleteRequest)
        //                } catch let error as NSError {
        //                    print("Could not delete. \(error), \(error.userInfo)")
        //                }
        
        
    }
    
    func save(q: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        for (index, _) in (self.fetchedResultsController?.sections?[0].objects?.enumerated())! {
            
            if let query = fetchedResultsController?.object(at: IndexPath(row: index, section: 0)) {
                if query.term! == q {
                    return
                }
            }
            
            
        }
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Query", in: managedContext)!
        let newQ = NSManagedObject(entity: entity, insertInto: managedContext)
        
        newQ.setValue(q, forKeyPath: "term")
        
        do {
            try managedContext.save()
            self.loadFromCD()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    
}
