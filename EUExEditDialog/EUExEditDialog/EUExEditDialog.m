//
//  EUExEditDialog.m
//  AppCan
//
//  Created by AppCan on 12-8-23.
//  Copyright (c) 2012年 AppCan. All rights reserved.
//

#import "EUExEditDialog.h"

static inline NSString * newUUID(){
    return [NSUUID UUID].UUIDString;
}
@implementation EUExEditDialog
#pragma mark -
#pragma mark superFun
//-(id)initWithBrwView:(EBrowserView *) eInBrwView{	
//	if (self = [super initWithBrwView:eInBrwView]) {
//        EDDict=[[NSMutableDictionary alloc] initWithCapacity:5];
//	}
//	return self;
//}
-(id)initWithWebViewEngine:(id<AppCanWebViewEngineObject>)engine{
    if (self = [super initWithWebViewEngine:engine]) {
        EDDict=[[NSMutableDictionary alloc] initWithCapacity:5];
    }
    return self;
}
//-(void)dealloc{
//    if (EDDict) {
//		for (EditDialog *edObj in [EDDict allValues]) {
//			if (edObj) {
//				edObj = nil;
//			}
//		}
//        EDDict = nil;
//	}
//}
-(void)clean{
    if (EDDict) {
        [EDDict removeAllObjects];
        EDDict = nil;
	}
}
#pragma mark -
#pragma mark JSFun

-(void)open:(NSMutableArray *)inArguments{
    NSString *key =[inArguments objectAtIndex:0];
    EditDialog *edView = [EDDict objectForKey:key];
    if (edView) {
        [EDDict removeObjectForKey:key];
        //[super jsSuccessWithName:@"uexEditDialog.cbOpen" opId:[key intValue] dataType:2 intData:1];
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexEditDialog.cbOpen" arguments:ACArgsPack(@([key intValue]),@2,@1)];
        return;
    }
    edView =[[EditDialog alloc] initWithEuex:self];
    edView.delegate = self;
    [edView showView:inArguments];
    [EDDict setObject:edView forKey:key];
    //[super jsSuccessWithName:@"uexEditDialog.cbOpen" opId:[key intValue] dataType:2 intData:0];
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexEditDialog.cbOpen" arguments:ACArgsPack(@([key intValue]),@2,@0)];

}
/***********新增create接口，替换open**********/
-(NSString*)create:(NSMutableArray *)inArguments{
    ACArgsUnpack(NSDictionary *dic) = inArguments;
    NSLog(@"dic:%@",dic);
    NSString *key = stringArg(dic[@"id"]) ?: newUUID();
    NSLog(@"key:%@",key);
    EditDialog *edView = [EDDict objectForKey:key];
    if (edView) {
        //[EDDict removeObjectForKey:key];
        //[super jsSuccessWithName:@"uexEditDialog.cbOpen" opId:[key intValue] dataType:2 intData:1];
        //[self.webViewEngine callbackWithFunctionKeyPath:@"uexEditDialog.cbOpen" arguments:ACArgsPack(@([key intValue]),@2,@1)];
        return nil;
    }
    edView =[[EditDialog alloc] initWithEuex:self];
    edView.delegate = self;
    [edView showNewView:inArguments idStr:key];
    [EDDict setObject:edView forKey:key];
    return key;
}
-(NSString*)insertData:(NSMutableArray *)inArguments{
    ACArgsUnpack(NSDictionary *dic) = inArguments;
    NSString *key = stringArg(dic[@"id"]) ?: newUUID();
    EditDialog *edView = [EDDict objectForKey:key];
    if (!edView) {
        return nil;
    }
    NSString *str =stringArg(dic[@"text"]);
    if (str && str.length>0) {
        [edView insertNewContent:str];
    }
    //[super jsSuccessWithName:@"uexEditDialog.cbInsert" opId:0 dataType:2 intData:0];
    //[self.webViewEngine callbackWithFunctionKeyPath:@"uexEditDialog.cbInsert" arguments:ACArgsPack(@([key intValue]),@2,@0)];
    return key;
}
/**************************************/
-(NSNumber*)close:(NSMutableArray *)inArguments{
    NSString *key =[inArguments objectAtIndex:0];
    EditDialog *edView = [EDDict objectForKey:key];
    if (edView) {
        [edView closeView];
        [EDDict removeObjectForKey:key];
        //[super jsSuccessWithName:@"uexEditDialog.cbClose" opId:[key intValue] dataType:2 intData:0];
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexEditDialog.cbClose" arguments:ACArgsPack(@([key intValue]),@2,@0)];

        return @(YES);
    }
    //[super jsSuccessWithName:@"uexEditDialog.cbClose" opId:[key intValue] dataType:2 intData:1];
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexEditDialog.cbClose" arguments:ACArgsPack(@([key intValue]),@2,@1)];
     return @(NO);
}

-(void)insert:(NSMutableArray *)inArguments{
    NSString *key =[inArguments objectAtIndex:0];
    EditDialog *edView = [EDDict objectForKey:key];
    if (!edView) {
        //[super jsSuccessWithName:@"uexEditDialog.cbInsert" opId:0 dataType:2 intData:1];
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexEditDialog.cbInsert" arguments:ACArgsPack(@([key intValue]),@2,@1)];
        return;
    }
    NSString *str =[inArguments objectAtIndex:1];
    if (str && str.length>0) {
        [edView insertContent:str];
    }
    //[super jsSuccessWithName:@"uexEditDialog.cbInsert" opId:0 dataType:2 intData:0];
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexEditDialog.cbInsert" arguments:ACArgsPack(@([key intValue]),@2,@0)];
}

-(NSNumber*)cleanAll:(NSMutableArray *)inArguments{
    NSString *key =[inArguments objectAtIndex:0];
    EditDialog *edView = [EDDict objectForKey:key];
    if (!edView) {
        //[super jsSuccessWithName:@"uexEditDialog.cbCleanAll" opId:0 dataType:2 intData:1];
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexEditDialog.cbCleanAll" arguments:ACArgsPack(@([key intValue]),@2,@1)];

        return @(NO);
    }
    
    [edView cleanAllData];
     //[super jsSuccessWithName:@"uexEditDialog.cbCleanAll" opId:0 dataType:2 intData:0];
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexEditDialog.cbCleanAll" arguments:ACArgsPack(@([key intValue]),@2,@0)];
    return @(YES);
}

-(NSString*)getContent:(NSMutableArray *)inArguments{
    NSString *key =[inArguments objectAtIndex:0];
    EditDialog *edView = [EDDict objectForKey:key];
    if (!edView) {
        //[super jsSuccessWithName:@"uexEditDialog.cbGetContent" opId:0 dataType:0 strData:@""];
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexEditDialog.cbGetContent" arguments:ACArgsPack(@([key intValue]),@0,@"")];
        return @"";
    }
    NSString *outStr =[edView getContent];
    //[super jsSuccessWithName:@"uexEditDialog.cbGetContent" opId:0 dataType:0 strData:outStr];
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexEditDialog.cbGetContent" arguments:ACArgsPack(@([key intValue]),@0,outStr)];
    return outStr;
}


#pragma mark -
#pragma mark delegate 
-(void)remainTextNum:(int)outNum opId:(NSString *)inOpId{
    EditDialog *edView = [EDDict objectForKey:inOpId];
    if (edView) {
       // NSString *jsStr = [NSString stringWithFormat:@"if(uexEditDialog.onNum!=null){uexEditDialog.onNum(%d,\'%d\')}",[inOpId intValue],outNum];
        //[meBrwView stringByEvaluatingJavaScriptFromString:jsStr];
        [self.webViewEngine callbackWithFunctionKeyPath:@"uexEditDialog.onNum" arguments:ACArgsPack(@([inOpId intValue]),[@(outNum) stringValue])];
    }
    
}
@end
