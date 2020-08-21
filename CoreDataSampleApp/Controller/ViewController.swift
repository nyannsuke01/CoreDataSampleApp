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

    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // planArray配列を定義 //realmのときの書き方を修正
    var planArray : [Plan] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }

    // 入力画面から戻ってきた時にTableViewを更新させる　(全件表示)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        tableView.reloadData()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Cellに値を設定する.
        let plan = planArray[indexPath.row]
        cell.textLabel?.text = plan.title

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        let fromDateString:String = formatter.string(from: plan.date_from!)
        let toDateString:String = formatter.string(from: plan.date_to!)

        cell.detailTextLabel?.text = fromDateString + " ~ " + toDateString
        
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

            let deletePlanCell = planArray[indexPath.row]
            managedContext.delete(deletePlanCell)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                planArray = try managedContext.fetch(Plan.fetchRequest())
            }
            catch{
                print("読み込み失敗！")
            }
        }
        tableView.reloadData()
    }

    func getData() {
        //取得してきたPlanを全件表示
        do{
            planArray = try managedContext.fetch(Plan.fetchRequest())
        }
        catch{
            print("読み込み失敗")
        }
    }

    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let EditPlanViewController:EditPlanViewController = segue.destination as! EditPlanViewController

        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            //indexPath!.row番目のタスクをEditPlanViewControllerに渡す
            EditPlanViewController.plan = planArray[indexPath!.row]
        } else {
            //+ボタンでの遷移　Plan新規作成のとき
            // Planのエンティティを指定
            let entity = NSEntityDescription.entity(forEntityName: "Plan", in: managedContext)
            let plan = Plan(entity: entity!, insertInto: managedContext)
              // データ初期化
            plan.title = ""
            plan.detail = ""
            plan.date_from = Date()
            plan.date_to = Date()
            //(不明点: realm を使わずallPlansを定義したい)
            var allPlans = [] as NSArray
            do {
                allPlans = try managedContext.fetch(Plan.fetchRequest()) as NSArray
            }catch{
              // エラーのときのコード
                print("読み込み失敗")
            }
            print("作成されるセルは" + String(allPlans.count) + "番目です")
            if allPlans.count != 0 {
                plan.id = Int32(Int(allPlans.count))
            }
            EditPlanViewController.plan = plan
        }
    }
}

