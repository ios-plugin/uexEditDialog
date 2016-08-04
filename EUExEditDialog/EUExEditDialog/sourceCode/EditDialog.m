//
//  EditDialog.m
//  AppCan
//
//  Created by AppCan on 12-8-23.
//  Copyright (c) 2012年 AppCan. All rights reserved.
//

#import "EditDialog.h"
#import "EUExEditDialog.h"
#import "EUtility.h"
#import  <QuartzCore/QuartzCore.h>

@implementation EditDialog


-(void)dealloc{
    if (edView) {
        [edView removeFromSuperview];
        edView =nil;
    }
    
    if (hintLab) {
        [hintLab removeFromSuperview];
        
        hintLab =nil;
    }
        self.delegate = nil;
    opId = nil;
    
}

-(id)initWithEuex:(EUExEditDialog*)inObj{
    uexObj =inObj;
    return self;
}

-(void)closeView{
    [edView removeFromSuperview];
}

-(void)insertNewContent:(NSString*)inContent{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString *newStr =[NSMutableString stringWithString:edView.text];
        [newStr insertString:inContent atIndex:location];
        edView.text = newStr;
        int existTextNum = [edView.text length];
        if (maxNum > 0) {
            int remainTextNum =maxNum - existTextNum;
            if (_delegate && [_delegate respondsToSelector:@selector(remainTextNum:opId:)]) {
                [_delegate remainTextNum:remainTextNum opId:opId];
            }
        }
    });
   
}
-(void)cleanAllData{
    dispatch_async(dispatch_get_main_queue(), ^{
        edView.text =@"";
    });
}
-(NSString*)getContent{
    return edView.text;
}
#pragma mark -
#pragma mark clickEvent
-(void)showView:(NSMutableArray*)inArguments{
    NSMutableArray *args =[NSMutableArray arrayWithArray:inArguments];
    opId =[[NSString alloc] initWithString:[inArguments objectAtIndex:0]];
    float ex = [[args objectAtIndex:1] floatValue];
    float ey = [[args objectAtIndex:2] floatValue];
    float ew = [[args objectAtIndex:3] floatValue];
    float eh = [[args objectAtIndex:4] floatValue];
    float fontSize =[[args objectAtIndex:5] floatValue];
    NSString *fontColorStr =[args objectAtIndex:6];
    UIColor *fontColor = [EUtility ColorFromString:fontColorStr];
    int eType = [[args objectAtIndex:7] intValue];
    NSString *eHintString = [args objectAtIndex:8];
    NSString *eDefString = [args objectAtIndex:9];
    maxNum = 0;
    int maxSize =[[args objectAtIndex:10] intValue];
    if (maxSize!=0) {
        maxNum = maxSize;
    }
    edView = [[UITextView alloc] initWithFrame:CGRectMake(ex, ey, ew, eh)];
    edView.backgroundColor =[UIColor clearColor];
    edView.font =[UIFont systemFontOfSize:fontSize];
    edView.textColor =fontColor;
    [edView setEditable:YES];
    [edView setDelegate:self];
    [edView.layer setCornerRadius:5.0];
    [edView.layer setBorderWidth:1.0];
    [edView.layer setBorderColor:[[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0] CGColor]];
    
    switch (eType) {
        case 0:
            //default
            [edView setKeyboardType:UIKeyboardTypeDefault];
            break;
        case 1:
            //NumberKB
            [edView setKeyboardType:UIKeyboardTypeNumberPad];
            break;
        case 2:
            //EmailKB
            [edView setKeyboardType:UIKeyboardTypeEmailAddress];
            break;
        case 3:
            //URLKB
            [edView setKeyboardType:UIKeyboardTypeURL];
            break;
        case 4:
            //PassWordKB
            edView.secureTextEntry = YES;
            break;
        case 5:
            [edView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            break;
            /* case 6:
             [textView.internalTextView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
             break;
             case 7:
             [textView.internalTextView setKeyboardType:UIKeyboardTypePhonePad];
             break;
             case 8:
             [textView.internalTextView setKeyboardType:UIKeyboardTypeNamePhonePad];
             break;
             case 9:
             [textView.internalTextView setKeyboardType:UIKeyboardTypeDecimalPad];
             break;   */
        default:
            break;
    }
    
    if(eDefString && eDefString.length>0){
        [edView setText:eDefString];
    }else {
        if(eHintString && eHintString.length>0)
        {
            hintLab = [[UILabel alloc] initWithFrame:CGRectMake(3, 2, ew-6, 20)];
            hintLab.backgroundColor =[UIColor clearColor];
            hintLab.text = eHintString;
            hintLab.font =[UIFont systemFontOfSize:fontSize];
            hintLab.textAlignment = UITextAlignmentLeft;
            hintLab.textColor = fontColor;
            [edView addSubview:hintLab];
        }
    }
    
    //[EUtility brwView:uexObj.meBrwView addSubview:edView];
    [[uexObj.webViewEngine webView] addSubview:edView];
    
}


-(void)showNewView:(NSMutableArray*)inArguments idStr:(NSString *)idStr{
    ACArgsUnpack(NSDictionary *dic) = inArguments;
    NSLog(@"dic:%@",dic);
    //NSMutableArray *args =[NSMutableArray arrayWithArray:inArguments];
    opId = idStr;
    NSLog(@"opId:%@",opId);
    float ex = [ac_numberArg(dic[@"x"]) floatValue];
    float ey = [ac_numberArg(dic[@"y"]) floatValue];
    float ew = [ac_numberArg(dic[@"width"]) floatValue];
    float eh = [ac_numberArg(dic[@"height"]) floatValue];
    float fontSize =[ac_numberArg(dic[@"fontSize"]) floatValue];
    NSString *fontColorStr = ac_stringArg(dic[@"fontColor"]);
    UIColor *fontColor = [EUtility ColorFromString:fontColorStr];
     int eType = [ac_numberArg(dic[@"inputType"]) intValue];
    NSString *eHintString = ac_stringArg(dic[@"inputHint"]);
    NSString *eDefString = ac_stringArg(dic[@"defaultText"]);
    maxNum = 0;
    int maxSize =[ac_numberArg(dic[@"maxNum"]) intValue];
    if (maxSize!=0) {
        maxNum = maxSize;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        edView = [[UITextView alloc] initWithFrame:CGRectMake(ex, ey, ew, eh)];
        edView.backgroundColor =[UIColor clearColor];
        edView.font =[UIFont systemFontOfSize:fontSize];
        edView.textColor =fontColor;
        [edView setEditable:YES];
        [edView setDelegate:self];
        [edView.layer setCornerRadius:5.0];
        [edView.layer setBorderWidth:1.0];
        [edView.layer setBorderColor:[[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0] CGColor]];
        
        switch (eType) {
            case 0:
                //default
                [edView setKeyboardType:UIKeyboardTypeDefault];
                break;
            case 1:
                //NumberKB
                [edView setKeyboardType:UIKeyboardTypeNumberPad];
                break;
            case 2:
                //EmailKB
                [edView setKeyboardType:UIKeyboardTypeEmailAddress];
                break;
            case 3:
                //URLKB
                [edView setKeyboardType:UIKeyboardTypeURL];
                break;
            case 4:
                //PassWordKB
                edView.secureTextEntry = YES;
                break;
            case 5:
                [edView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
                break;
                /* case 6:
                 [textView.internalTextView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
                 break;
                 case 7:
                 [textView.internalTextView setKeyboardType:UIKeyboardTypePhonePad];
                 break;
                 case 8:
                 [textView.internalTextView setKeyboardType:UIKeyboardTypeNamePhonePad];
                 break;
                 case 9:
                 [textView.internalTextView setKeyboardType:UIKeyboardTypeDecimalPad];
                 break;   */         
            default:
                break;
        }
        if(eDefString && eDefString.length>0){
            [edView setText:eDefString];
        }else {
            if(eHintString && eHintString.length>0)
            {
                hintLab = [[UILabel alloc] initWithFrame:CGRectMake(3, 2, ew-6, 20)];
                hintLab.backgroundColor =[UIColor clearColor];
                hintLab.text = eHintString;
                hintLab.font =[UIFont systemFontOfSize:fontSize];
                hintLab.textAlignment = UITextAlignmentLeft;
                hintLab.textColor = fontColor;
                [edView addSubview:hintLab];
            }
        }
        
        //[EUtility brwView:uexObj.meBrwView addSubview:edView];
        [[uexObj.webViewEngine webView] addSubview:edView];
        
    });
    
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return  YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (hintLab) {
        [hintLab removeFromSuperview];
    }
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
}

- (void)textViewDidChange:(UITextView *)textView{
    int existTextNum = [edView.text length]; 
    if (maxNum > 0) {
        int remainTextNum =maxNum - existTextNum;
       
            if (_delegate && [_delegate respondsToSelector:@selector(remainTextNum:opId:)]) {
                [_delegate remainTextNum:remainTextNum opId:opId];
            }
    }
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
    location = textView.selectedRange.location;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //计算剩下多少文字可以输入  
    if(range.location>=maxNum){  
        return NO;  
    } 
    return YES;
}
@end
