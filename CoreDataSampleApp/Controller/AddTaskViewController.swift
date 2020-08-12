//
//  AddTaskViewController.swift
//  CoreDataSampleApp
//
//  Created by user on 2020/08/09.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        detailTextView.delegate = self
    }
    // ①Planを新規作成(追加)する処理
    // CoreDataに指令を出すmanagedObjectContextを生成
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    // (不明点)appDelegateにmanagedObjectContextがないようですが、別に定義されたものを使うのでしょうか？
    let managedContext: NSManagedObjectContext = appDelegate.managedObjectContext

    // Taskエンティティを指定
    let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedContext)
    let task = Task(entity: entity!, insertInto: managedContext)
    // データ追加
    plan.id = 1
    plan.title = "市場"
    // 保存
    do{
        try managedObjectContext.save()
    }catch{

    }

    // ②セルが選択されてこの画面に来た場合のPlanの編集(更新)処理
    // 更新するデータを指定する。この場合ショップ名が市場のレコード。
    let predict = NSPredicate(format: "%K=%@", "name", "市場")
    fetchReq.predicate = predict
    // データを格納する空の配列を用意
    var results = []
    // 読み込み実行
    do {
        results = try managedObjectContext.executeFetchRequest(fetchReq)
    }catch{

    }

    let shop = results[0] as! Shop
    shop.id = 2
    shop.name = "牧場"
    // 保存
    do{
        try managedObjectContext.save()
    }catch{

    }



}
