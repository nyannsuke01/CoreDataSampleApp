//
//  TaskViewController.swift
//  CoreDataSampleApp
//
//  Created by user on 2020/08/09.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    
    //コンテキスト作成
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // taskArray配列を定義
    var taskArray : [Task] = []
    //planIdの定義
    var planId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // 入力画面から戻ってきた時にTableViewを更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        tableView.reloadData()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        //taskCellに値を設定する
        let task = taskArray[indexPath.row]
        taskCell.textLabel?.text = task.title
        
        return taskCell
    }

    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "taskCellSegue", sender: nil)
    }

    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let task = taskArray[indexPath.row]
            managedContext.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                taskArray = try managedContext.fetch(Task.fetchRequest())
            }
            catch{
                print("読み込み失敗！")
            }
        }
        tableView.reloadData()
    }


    func getData() {
        // リレーションさせるデータをTaskテーブルから読込
        // 読み込むエンティティを指定
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        // データを指定する。この場合ショップ名が市場のレコード。
        fetchRequest.predicate = NSPredicate(format: "plan_id = %@", planId)
        //取得してきたTaskを全件表示
        do{
            taskArray = try managedContext.fetch(fetchRequest)
        }
        catch{
            print("読み込み失敗")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let AddTaskViewController:AddTaskViewController = segue.destination as! AddTaskViewController

        if segue.identifier == "taskCellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow

            AddTaskViewController.task = taskArray[indexPath!.row]
        } else {
            //+ボタンでの遷移　Task新規作成のとき
            // Taskのエンティティを指定
            let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)
            let task = Task(entity: entity!, insertInto: managedContext)
            // データ初期化
            task.title = ""
            task.detail = ""
            //allTasksを定義
            var allTasks = [] as NSArray
            do {
                allTasks = try managedContext.fetch(Task.fetchRequest()) as NSArray
            } catch {
              // エラーのときのコード
                print("読み込み失敗")
            }
            print("作成されるセルは" + String(allTasks.count) + "番目です")
            if allTasks.count != 0 {
                task.id = Int32(Int(allTasks.count))
            }
            AddTaskViewController.task = task
        }
    }
}
