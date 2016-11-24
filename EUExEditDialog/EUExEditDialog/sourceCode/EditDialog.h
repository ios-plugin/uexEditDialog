//
//  EditDialog.h
//  AppCan
//
//  Created by AppCan on 12-8-23.
//  Copyright (c) 2012年 AppCan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EUExEditDialog;

@protocol EditDialogDelegate <NSObject>
-(void)remainTextNum:(int)outNum opId:(NSString*)inOpId;
@end

@interface EditDialog : NSObject<UITextViewDelegate>{
    EUExEditDialog *uexObj;
    UITextView *edView;
    UILabel *hintLab;
    //UIView *containView;
    int maxNum;
    int location;
    NSString *opId;
}
@property(nonatomic,assign)id<EditDialogDelegate> delegate;
-(id)initWithEuex:(EUExEditDialog*)inObj;
-(void)showView:(NSMutableArray*)inArguments;
-(void)showNewView:(NSMutableArray*)inArguments idStr:(NSString*)idStr;
-(void)closeView;
-(void)insertNewContent:(NSString*)inContent;
-(void)cleanAllData;
-(NSString*)getContent;
@end
