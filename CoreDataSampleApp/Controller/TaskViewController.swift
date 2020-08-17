//
//  TaskViewController.swift
//  CoreDataSampleApp
//
//  Created by user on 2020/08/09.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    // taskArray配列を定義
    var taskArray : [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // 入力画面から戻ってきた時にTableViewを更新させる　(全件表示)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        tableView.reloadData()

    }
    func getData() {
        //コンテキスト作成
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //取得してきたPlanを全件表示
        do{
            taskArray = try managedContext.fetch(Task.fetchRequest())
        }
        catch{
            print("読み込み失敗")
        }
    }

}
