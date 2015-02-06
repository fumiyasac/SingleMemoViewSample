//
//  ViewController.swift
//  singleMemoViewSample
//
//  Created by 酒井文也 on 2015/01/31.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

import UIKit
import CoreData

class MemoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //一覧用のテーブルビュー
    @IBOutlet var memoTableView: UITableView!
    
    //テーブルビューの要素数(今回は決めうちだからこれで)
    let sectionCount: Int = 1
    
    //テーブルビューセルの高さ(Xibのサイズに合わせるのが理想)
    let tableViewCellHeight: CGFloat = 140.0
    
    //テーブル内のセル表示数
    var fetchCount :Int!
    
    //エンティティ名
    let entityName: String = "Memo"
    
    //CoreDataを格納する可変配列
    var fetchDataArray: AnyObject?
    
    //画面表示前に実行される
    override func viewWillAppear(animated: Bool) {
        
        //テーブルビューをリロードする
        self.memoTableView.reloadData()
        
        //CoreDataからメモ一覧を呼び出す
        self.selectRecordAndCountToCoreData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //カウントの初期値を設定
        fetchCount = 0
        
        //tableViewデリゲート
        self.memoTableView.delegate = self
        self.memoTableView.dataSource = self
        
        //Xibのクラスを読み込む宣言を行う
        var nib:UINib = UINib(nibName: "MemoTableViewCell", bundle: nil)
        self.memoTableView.registerNib(nib, forCellReuseIdentifier: "MemoCell")
        
    }
    
    //テーブルの行数を設定する ※必須
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchCount
    }
    
    //テーブルの要素数を設定する ※必須
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionCount
    }
    
    //表示するセルの中身を設定する ※必須
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        var cell = tableView.dequeueReusableCellWithIdentifier("MemoCell") as MemoTableViewCell;
        var item: AnyObject? = fetchDataArray?.objectAtIndex(indexPath.row)
        
        //CoreDataからテーブルセルに値をセットする処理を記述
        cell.titleText?.text  = item?.valueForKey("title") as? String
        cell.detailText?.text = item?.valueForKey("detail") as? String
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        return cell
    }
    
    //セルをタップした時に呼び出される ※必須
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var item: AnyObject? = fetchDataArray?.objectAtIndex(indexPath.row)
        var itemArray = [String]()
        
        var memoIdValue : AnyObject? = item?.valueForKey("memo_id")
        var titleValue  : String? = item?.valueForKey("title") as? String
        var detailValue : String? = item?.valueForKey("detail") as? String
        
        //IDはOptional型でとってくるので強引に型変換をかける
        var memo_id : String = "\(memoIdValue!)"
        var title   : String = titleValue!
        var detail  : String = detailValue!
        
        itemArray.append(memo_id)
        itemArray.append(title)
        itemArray.append(detail)
        
        self.performSegueWithIdentifier("toEdit", sender: itemArray)
    }
    
    //segueを呼び出したときに呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //新規追加ボタンを押す(追加) or テーブルビュータップ(編集)
        if segue.identifier == "toEdit"{
            var memoAddViewController = segue.destinationViewController as MemoAddViewController
            memoAddViewController.dataArray = sender as NSArray
        }
        
    }
    
    //セルの高さを返す
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableViewCellHeight
    }
    
    //データのリロード
    func reloadData(){
        self.memoTableView.reloadData()
    }
    
    //CoreDataよりメモ一覧を取得する
    func selectRecordAndCountToCoreData() {
        
        //エラー格納用の変数
        var error: NSError?

        //NSManagedObjectContext取得
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext!

        //フェッチリクエストと条件の設定
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"memo_id > 0")

        //フェッチ結果
        let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
                
        //データの取得処理成功時
        if let results: AnyObject = fetchResults {

            //データのカウント数を取得
            fetchCount = results.count
            
            //データをメンバ変数に格納する
            fetchDataArray = results
            
        //失敗時
        } else {
            println("Could not fetch \(error) , \(error!.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func dataAddBtn(sender: UIButton) {
        //空っぽの配列を準備
        var item :NSArray = ["","",""]
        self.performSegueWithIdentifier("toEdit", sender: item)
    }

}

