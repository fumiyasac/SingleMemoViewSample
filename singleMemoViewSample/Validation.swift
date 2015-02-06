//
//  Validation.swift
//  singleMemoViewSample
//
//  Created by 酒井文也 on 2015/02/04.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

import UIKit

struct Validation {
    
    // 文字列が空かを判定
    // ※バリデーションルールはパターンが色々あるので、使い回せるように分けておく
    static func checkExistString(checkString:String) -> Bool{
        
        if(checkString == ""){
            return false
        }else{
            return true
        }
    }
    
}
