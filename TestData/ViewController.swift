//
//  ViewController.swift
//  TestData
//
//  Created by moxDroid on 2017-03-28.
//  Copyright © 2017 moxDroid. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var myMovie: [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        save(mid: 1, mname: "After Delete added")
       // deletMovie(mid: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func save(mid: Int, mname: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Movie",
                                       in: managedContext)!
        
        let movie = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        movie.setValue(mid, forKeyPath: "movieId")
        movie.setValue(mname, forKeyPath: "movieName")
        
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "movieName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Add Predicate
        //let predicate = NSPredicate(format: "movieName CONTAINS[c] %@", "o")
        //fetchRequest.predicate = predicate
        
        // Add Predicate
        let predicate1 = NSPredicate(format: "movieId >= 1")
        //let predicate2 = NSPredicate(format: "%K = %@", "list.name", "Home")
        //fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        fetchRequest.predicate = predicate1
        
        
        
        //3
       
        do {
            myMovie = try managedContext.fetch(fetchRequest)

            for m in myMovie
            {
                print((m as! Movie).movieName!)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deletMovie(mid: Int16)
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
    
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        
        // Add Predicate - Condition to get Movie
        let predicate1 = NSPredicate(format: "movieId = 1")
        
        fetchRequest.predicate = predicate1
        
        
        do {
            myMovie = try managedContext.fetch(fetchRequest)
    
            managedContext.delete(myMovie[0])
            print("Movie Deleted Successfully...")
            
            // 4
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Could not delete movie. \(error), \(error.userInfo)")
        }

    }
    
}

