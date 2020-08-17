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

    var plan: Plan!

    // CoreDataに指令を出すmanagedContextを生成
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)

        titleTextField.delegate = self
        detailTextView.delegate = self

//        titleTextField?.text = plan.title
//        detailTextView?.text = plan.detail
//        fromDatePicker?.date = plan.date_to!
//        toDatePicker?.date = plan.date_from!
    }

    override func viewWillDisappear(_ animated: Bool) {
        // CoreDataに指令を出すmanagedContextを生成
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

       // let plan = Plan(context: managedContext)

        // Shopエンティティを指定
        let entity = NSEntityDescription.entity(forEntityName: "Plan", in: managedContext)
        let plan = Plan(entity: entity!, insertInto: managedContext)
        plan.title = titleTextField.text!
        plan.detail = detailTextView.text!
        plan.date_from = fromDatePicker.date
        plan.date_to = toDatePicker.date
        //保存
      //  (UIApplication.shared.delegate as! AppDelegate).saveContext()
        do{
             try (UIApplication.shared.delegate as! AppDelegate).saveContext()
         }catch{
            print("保存ができませんでした")
         }
        
        super.viewWillDisappear(animated)
    }


    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }

    @IBAction func showTask(_ sender: Any) {
        self.performSegue(withIdentifier: "toTasks", sender: nil)
        
    }

}
