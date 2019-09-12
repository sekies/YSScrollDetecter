//
//  YSScrollDetecter.swift
//  Scroll
//
//  Created by Yosuke Seki on 2018/01/19.
//  Copyright © 2018年 Yosuke Seki. All rights reserved.
//

import UIKit

public class YSScrollDetecter: NSObject {
    public var topOffset:CGFloat = 0
    public var bottomOffset:CGFloat = 0
    var scrollBeforeY:CGFloat = 0
    var isScrolledThresholdForTop:Bool = false //スクロールを意図的にやめようとしているかどうか
    var isScrolledThresholdForBottom:Bool = false //スクロールを意図的にやめようとしているかどうか
    var scrolledFunctionIsReady:Bool = false //スクロール後に処理を行うことが確定しているかどうか
    
    var attentionForTop:(()->())?
    var attentionForBottom:(()->())?
    var attentionEndForTop:(()->())?
    var attentionEndForBottom:(()->())?
    var scrollingForTop:((CGFloat)->())?
    var scrollingForBottom:((CGFloat)->())?
    var scrollEndForTop:(()->())?
    var scrollEndForBottom:(()->())?
    
    init(topOffsetMax:CGFloat, bottomOffsetMax:CGFloat) {
        self.topOffset = topOffsetMax
        self.bottomOffset = bottomOffsetMax
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrolledFunctionIsReady){
            return
        }
        isScrolledThresholdForTop = !(scrollView.contentOffset.y > scrollBeforeY)
        
        
        let perTop:CGFloat = calcScrollPositionTop(scrollView)
        if(perTop > 1.0 && isScrolledThresholdForTop){
            scrollBeforeY = scrollView.contentOffset.y
            attentionForTop?()
            return
        }
        attentionEndForTop?()
        
        isScrolledThresholdForBottom = !(scrollView.contentOffset.y < scrollBeforeY)
        let perBottom:CGFloat = calcScrollPositionBottom(scrollView)
        if(perBottom > 1.0 && isScrolledThresholdForBottom){
            scrollBeforeY = scrollView.contentOffset.y
            attentionForBottom?()
            return
        }
        attentionEndForBottom?()
        
        scrollBeforeY = scrollView.contentOffset.y
        
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView) {
        if(!isScrolledThresholdForTop){
            if(!isScrolledThresholdForBottom){
                return
            }
            
            let perBottom:CGFloat = calcScrollPositionBottom(scrollView)
            if(perBottom > 1.0){
                //bottom
                scrolledFunctionIsReady = true
                scrollEndForBottom?()
                
                UIView.animate(
                    withDuration: 0.5,
                    animations: {
                },
                    completion:{ _ in
                        self.scrolledFunctionIsReady = false
                        self.isScrolledThresholdForBottom = false
                        self.scrollBeforeY = 0
                }
                )
            }
        }else{
            let perTop:CGFloat = calcScrollPositionTop(scrollView)
            if(perTop > 1.0){
                //top
                scrolledFunctionIsReady = true
                scrollEndForTop?()
                
                UIView.animate(
                    withDuration: 0.5,
                    animations: {
                },
                    completion:{ _ in
                        self.scrolledFunctionIsReady = false
                        self.isScrolledThresholdForTop = false
                        self.scrollBeforeY = 0
                }
                )
            }
        }
    }
    
    private func calcScrollPositionTop(_ scrollView: UIScrollView)->CGFloat{
        let per:CGFloat = scrollView.contentOffset.y / (-topOffset)
        scrollingForTop?(per)
        return per
    }
    
    private func calcScrollPositionBottom(_ scrollView: UIScrollView)->CGFloat{
        let per:CGFloat = (scrollView.contentOffset.y-(scrollView.contentSize.height-scrollView.frame.size.height)) / bottomOffset
        scrollingForBottom?(per)
        return per
    }
}
