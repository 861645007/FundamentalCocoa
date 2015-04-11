//
//  MenuOperating.m
//  FundamentalsCocoa
//
//  Created by 王焕强 on 15/4/8.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

#import "MenuOperating.h"
#import "CodeTypeOperating.h"
#import "ViewController.h"
#import "FundamentalsResultPanelViewController.h"

@interface MenuOperating () {
    FundamentalsResultPanelViewController *fundamentalsResultViewController;
}

@end


@implementation MenuOperating

#pragma mark - 打开文件
- (IBAction)openNewFundamenttals:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setPrompt: @"打开"];
    
    openPanel.allowedFileTypes = [NSArray arrayWithObjects: @"txt", @"doc", nil];
    openPanel.directoryURL = nil;
    
    [openPanel beginSheetModalForWindow:[self gainMainViewController] completionHandler:^(NSModalResponse returnCode) {
        
        if (returnCode == 1) {
            NSURL *fileUrl = [[openPanel URLs] objectAtIndex:0];
            // 获取文件内容
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:fileUrl error:nil];
            NSString *fileContext = [[NSString alloc] initWithData:fileHandle.readDataToEndOfFile encoding:NSUTF8StringEncoding];
            
            // 将 获取的数据传递给 ViewController 的 TextView
            ViewController *mainViewController = (ViewController *)[self gainMainViewController].contentViewController;
            mainViewController.showCodeTextView.string = fileContext;
        }
    }];
}

#pragma mark - 词法分析
- (IBAction)lexicalAnalysis:(id)sender {
    // 将 获取的数据传递给 ViewController 的 TextView
    ViewController *mainViewController = (ViewController *)[self gainMainViewController].contentViewController;
    CodeTypeOperating *codeTypeOperating = [[CodeTypeOperating alloc] init];
    
    // 进行 词法分析
    [codeTypeOperating dealWithCode:mainViewController.showCodeTextView.string];
    
    // 将 词法分析 的正确部分 放到主界面的相应位置
    [mainViewController dealWithToken:codeTypeOperating.tokenArr];
    
    // 将 词法分析 的错误部分 放到主界面的相应位置
    mainViewController.showResultTextView.string = [self dealWithFalseInfo:codeTypeOperating.falseWordArr];
    
    // 保存 至 文件
    [codeTypeOperating saveSymbolToFile];
    [codeTypeOperating saveTokenToFile];
}


// 处理错误信息
- (NSString *)dealWithFalseInfo:(NSArray *)falseWordArr {
    
    NSMutableString *falseInfoString = [NSMutableString string];
    if ([falseWordArr count] != 0) {
        [falseInfoString appendFormat:@"程序有错：\n"];
        for (NSDictionary *falseDic in falseWordArr) {
            [falseInfoString appendFormat:@"\t第%@行： 信息：%@\n", [falseDic objectForKey:@"rowNumber"], [falseDic objectForKey:@"name"]];
        }
    }else {
        [falseInfoString appendString:@"暂无错误!"];
    }
    
    
    return falseInfoString;
}


#pragma mark - 编译
- (IBAction)fundamentalCode:(id)sender {
    ViewController *mainViewController = (ViewController *)[self gainMainViewController].contentViewController;
    
    
    if (!fundamentalsResultViewController) {
        fundamentalsResultViewController = [[FundamentalsResultPanelViewController alloc] initWithWindowNibName:@"FundamentalsResultPanelViewController"];
    }
    
    [fundamentalsResultViewController showWindow:self];
    fundamentalsResultViewController.showFunResultTextView.string = mainViewController.showCodeTextView.string;
}


#pragma mark - 私有方法 
-(NSWindow *)gainMainViewController {
    return [NSApplication sharedApplication].windows[0];

}

@end
