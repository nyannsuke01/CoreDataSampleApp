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

    var task: Task!

    // CoreDataに指令を出すmanagedContextを生成
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        detailTextView.delegate = self

        titleTextField.text! = task.title!
        detailTextView.text! = task.detail!
    }

    override func viewWillDisappear(_ animated: Bool) {
        // データ追加
        task.title = titleTextField.text!
        task.detail = detailTextView.text!
        // 保存
        do{
            try managedContext.save()
        }catch{
            print("保存ができませんでした")
        }
    }
}
