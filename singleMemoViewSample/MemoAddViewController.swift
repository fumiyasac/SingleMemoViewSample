//
//  MemoAddViewController.swift
//  singleMemoViewSample
//
//  Created by 酒井文也 on 2015/02/01.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

import UIKit
import CoreData

class MemoAddViewController: UIViewController {
    
    //エンティティ名
    let entityName: String = "Memo"
    
    //MemoListViewControllerから渡される値
    var dataArray: NSArray!
    
    //編集時のメモID格納用
    var memo_id: String!
    
    //タイトル入力エリア
    @IBOutlet var titleFormArea: UITextField!
    
    //メモ本文入力エリア
    @IBOutlet var detailTextArea: UITextView!
    
    //各ボタンのプロパティ
    @IBOutlet var addButton:    UIButton!
    @IBOutlet var editButton:   UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("\(dataArray)")
        
        //senderから受け取った値を表示する
        if(self.dataArray[0] as NSString == ""){
            
            //ボタンのふるまい
            self.addButton.enabled    = true;
            self.editButton.enabled   = false;
            self.deleteButton.enabled = false;
            
            //ボタンのアルファ
            self.addButton.alpha    = 1.0;
            self.editButton.alpha   = 0.0;
            self.deleteButton.alpha = 0.0;
            
        }else{
            
            //ボタンのふるまい
            self.addButton.enabled    = false;
            self.editButton.enabled   = true;
            self.deleteButton.enabled = true;
            
            //ボタンのアルファ
            self.addButton.alpha    = 0.0;
            self.editButton.alpha   = 1.0;
            self.deleteButton.alpha = 1.0;
            
            //渡された値をセットする
            self.memo_id             = self.dataArray[0] as String
            self.titleFormArea.text  = self.dataArray[1] as String
            self.detailTextArea.text = self.dataArray[2] as String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //追加ボタン押下時のアクション
    @IBAction func addButtonTapped(sender: UIButton) {
        
        //CoreDataに新規追加する
        if(self.dataValidationForPut() == true){
            self.addMemoToCoreData()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //編集ボタン押下時のアクション
    @IBAction func editButtonTapped(sender: UIButton) {
        
        //該当データを編集する
        if(self.dataValidationForPut() == true){
            self.editMemoToCoreData()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //削除ボタン押下時のアクション
    @IBAction func deleteButtonTapped(sender: UIButton) {
        
        //該当データを削除する
        self.deleteMemoToCoreData()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //背景タップ時のアクション(キーボードを引っ込める)
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //バリデーション用の関数
    func dataValidationForPut() -> Bool {
        
        //バリデーション判定フラグのデフォルト値
        var validationFlag: Bool! = true;
        
        //データバリデーションに引っかかった際はエラーメッセージを表示
        if(!Validation.checkExistString(self.titleFormArea.text) || !Validation.checkExistString(self.detailTextArea.text)){
            validationFlag = false;
        }
        return validationFlag;
    }
    
    //該当のCoreDataレコードを削除
    func deleteMemoToCoreData() {
        
        //エラー格納用の変数
        var error: NSError?
        
        //NSManagedObjectContext取得
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        //フェッチリクエストと条件の設定
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"memo_id = \(self.memo_id)")
        
        //フェッチ結果
        let fetchResult: NSArray = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)!
        
        //削除対象のエンティティ
        let deleteMemoEntity = fetchResult.objectAtIndex(0) as NSManagedObject
        
        //NSManagedObjectContextから削除する
        managedObjectContext.deleteObject(deleteMemoEntity)
        
        if !managedObjectContext.save(&error) {
            abort()
        }
        
    }
    
    //該当のCoreDataレコードを編集 ※検索⇒変更の流れ
    func editMemoToCoreData() {
        
        //エラー格納用の変数
        var error: NSError?
        
        //NSManagedObjectContext取得
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        //フェッチリクエストと条件の設定
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"memo_id = \(self.memo_id)")
        
        //フェッチ結果
        let fetchResult: NSArray = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)!
        
        //更新対象のエンティティ
        let editMemoEntity = fetchResult.objectAtIndex(0) as NSManagedObject
        
        editMemoEntity.setValue(self.titleFormArea.text,   forKey:"title")
        editMemoEntity.setValue(self.detailTextArea.text,  forKey:"detail")
        
        if !managedObjectContext.save(&error) {
            abort()
        }
    }
    
    //データをCoreDataへ追加
    func addMemoToCoreData() {
        
        //NSManagedObjectContext取得
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        //新規追加
        let newMemoEntity = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext) as NSManagedObject
        
        newMemoEntity.setValue(Int(self.getNextMemoId()), forKey:"memo_id")
        newMemoEntity.setValue(self.titleFormArea.text,   forKey:"title")
        newMemoEntity.setValue(self.detailTextArea.text,  forKey:"detail")
        
        var error: NSError? = nil
        if !managedObjectContext.save(&error) {
            abort()
        }
    }
    
    //データのmemo_idの最大値を取得する
    func getNextMemoId() -> Int64 {
        
        //エラー格納用の変数
        var error: NSError?
        
        //NSManagedObjectContext取得
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        //フェッチリクエストと条件の設定
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        //検索条件を設定する
        let keyPathExpression = NSExpression(forKeyPath: "memo_id")
        let maxExpression = NSExpression(forFunction: "max:", arguments: [keyPathExpression])
        let description = NSExpressionDescription()
        description.name = "maxId"
        description.expression = maxExpression
        description.expressionResultType = .Integer32AttributeType
        
        //フェッチ結果を出力する
        fetchRequest.propertiesToFetch = [description]
        fetchRequest.resultType = .DictionaryResultType
        
        //フェッチ結果をreturn
        if let results = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) {
            if results.count > 0 {
                let maxId = results[0]["maxId"] as Int
                return maxId + 1;
            }
        }
        return 1
        
    }
    
}
