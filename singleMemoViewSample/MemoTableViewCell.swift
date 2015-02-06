//
//  MemoTableViewCell.swift
//  singleMemoViewSample
//
//  Created by 酒井文也 on 2015/02/01.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

import UIKit

class MemoTableViewCell: UITableViewCell {

    //可変対象のラベルインスタンス
    @IBOutlet var titleText: UILabel!
    @IBOutlet var detailText: UILabel!
    
    //可変ラベル幅のメンバ変数
    var targetLabelWidth: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //現在起動中のデバイスを取得（スクリーンの幅・高さ）
        let screenWidth = DeviseSize.screenWidth()
        let screenHeight = DeviseSize.screenHeight()
        
        //iPhone4s
        if(screenWidth == 320 && screenHeight == 480){

            targetLabelWidth = 290;
            
        //iPhone5またはiPhone5s
        }else if (screenWidth == 320 && screenHeight == 568){
            
            targetLabelWidth = 290;
            
        //iPhone6
        }else if (screenWidth == 375 && screenHeight == 667){
            
            targetLabelWidth = 345;
        
        //iPhone6 plus
        }else if (screenWidth == 414 && screenHeight == 736){
            
            targetLabelWidth = 384;
            
        }
        
        //表示用ラベルのフィックスをする
        self.titleText.frame = CGRectMake(15, 35, CGFloat(targetLabelWidth), 20);
        self.detailText.frame = CGRectMake(15, 90, CGFloat(targetLabelWidth), 40);
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
