//
//  Memo.swift
//  singleMemoViewSample
//
//  Created by 酒井文也 on 2015/01/31.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

import Foundation
import CoreData

class Memo: NSManagedObject {
    
    //CoreDataのカラムに対応するエンティティ
    @NSManaged var detail: String?
    @NSManaged var title: String?
    @NSManaged var memo_id: NSNumber?

}
