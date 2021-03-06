//
//  FundamentalsResultPanelViewController.h
//  FundamentalsCocoa
//
//  Created by 王焕强 on 15/4/7.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FundamentalsResultPanelViewController : NSWindowController

@property (unsafe_unretained) IBOutlet NSTextView *analyzeRightInfoTextView;
@property (unsafe_unretained) IBOutlet NSTextView *analyzeFalseInfoTextView;
@property (unsafe_unretained) IBOutlet NSTextView *analyzeQuaternionInfoTextView;

- (void)transformInfoRightToTextView:(NSArray *)infoList;
- (void)transformInfoQuaternionToTextView:(NSArray *)quaternionList;


@end
