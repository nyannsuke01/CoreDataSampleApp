//
//  ViewController.swift
//  CoreDataSampleApp
//
//  Created by user on 2020/08/08.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    // CoreDataに指令を出すmanagedContextを生成
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // taskArray配列を定義 //realmのときの書き方を修正
    var taskArray :[Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }

    // 入力画面から戻ってきた時にTableViewを更新させる　(全件表示)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        //複数回呼ばれるところで取得のコードを書けば良い
        // 読み込むエンティティを指定
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Plan")
        // データを格納する空の配列を用意
        var results = [] as NSArray
        // 読み込み実行
        do {
            results = try managedContext.fetch(fetchReq) as NSArray
        }catch{

        }
        // Planインスタンスを生成
        let plan = results[0] as! Plan
        // データにアクセス
        print(plan)

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Cellに値を設定する.
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

//        let dateString:String = formatter.string(from: task.date)
//        cell.detailTextLabel?.text = dateString
        
        return cell
    }

    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }

    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // データベースから削除する
//            try! realm.write {
//                //データの削除
//                self.realm.delete(self.taskArray[indexPath.row])
//                //テーブルの削除
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            }
        }
    }

    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let EditPlanViewController:EditPlanViewController = segue.destination as! EditPlanViewController

        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            //(不明点: indexPath!.row番目のタスクをEditPlanViewControllerに渡したい)
            EditPlanViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()
            //(不明点: realm を使わずallTasksを定義したい)
//            let allTasks = realm.objects(Task.self)
//            if allTasks.count != 0 {
//                task.id = allTasks.max(ofProperty: "id")! + 1
//            }

            EditPlanViewController.task = task
        }
    }


}

