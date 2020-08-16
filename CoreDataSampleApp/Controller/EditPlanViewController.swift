//
//  EditPlanViewController.swift
//  CoreDataSampleApp
//
//  Created by user on 2020/08/08.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import CoreData

class EditPlanViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!

    var task: Task!

    // CoreDataに指令を出すmanagedObjectContextを生成
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)

        titleTextField.delegate = self
        detailTextView.delegate = self

        titleTextField.text = task.title
        detailTextView.text = task.detail
//        fromDatePicker.date = task.date
//        toDatePicker.date = task.date

    }


    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }


}
