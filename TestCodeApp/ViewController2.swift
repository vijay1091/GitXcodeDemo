//
//  ViewController2.swift
//  TestCodeApp
//
//  Created by Vijay Kunal on 23/06/23.
//

import UIKit

class ViewController2: UIViewController {
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      printArray(collection: ["bbbc", "trte", "dsd", "sda"])
      
    }
    
    func printArray<T>(collection: [T]) {
        for item in collection {
            print(item, terminator: " ")
        }
    }
   
}



