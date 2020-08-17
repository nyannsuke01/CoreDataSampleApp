//
//  AddTaskViewController.swift
//  CoreDataSampleApp
//
//  Created by user on 2020/08/09.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        detailTextView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    override func viewWillDisappear(_ animated: Bool) {
        // CoreDataに指令を出すmanagedContextを生成
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Taskエンティティを指定
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)
        let task = Task(entity: entity!, insertInto: managedContext)
        // データ追加
        task.title = titleTextField.text!
        task.detail = detailTextView.text!
        // 保存
        do{
            try managedContext.save()
        }catch{

        }
    }
}
