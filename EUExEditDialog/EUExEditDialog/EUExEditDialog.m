//
//  EUExEditDialog.m
//  AppCan
//
//  Created by AppCan on 12-8-23.
//  Copyright (c) 2012年 AppCan. All rights reserved.
//

#import "EUExEditDialog.h"

@implementation EUExEditDialog
#pragma mark -
#pragma mark superFun
-(id)initWithBrwView:(EBrowserView *) eInBrwView{	
	if (self = [super initWithBrwView:eInBrwView]) {
        EDDict=[[NSMutableDictionary alloc] initWithCapacity:5];
	}
	return self;
}

-(void)dealloc{
    if (EDDict) {
		for (EditDialog *edObj in [EDDict allValues]) {
			if (edObj) {
				[edObj release];
				edObj = nil;
			}
		}
        [EDDict release];
        EDDict = nil;
	}
	[super dealloc];
}
-(void)clean{
    if (EDDict) {
		for (EditDialog *edObj in [EDDict allValues]) {
			if (edObj) {
				[edObj release];
				edObj = nil;
			}
		}
        [EDDict release];
        EDDict = nil;
	}
}
#pragma mark -
#pragma mark JSFun

-(void)open:(NSMutableArray *)inArguments{
    NSString *key =[inArguments objectAtIndex:0];
    EditDialog *edView = [EDDict objectForKey:key];
    if (edView) {
        [edView release];
        [EDDict removeObjectForKey:key];
        [super jsSuccessWithName:@"uexEditDialog.cbOpen" opId:[key intValue] dataType:2 intData:1];
        return;
    }
    edView =[[EditDialog alloc] initWithEuex:self];
    edView.delegate = self;
    [edView showView:inArguments];
    [EDDict setObject:edView forKey:key];
    [super jsSuccessWithName:@"uexEditDialog.cbOpen" opId:[key intValue] dataType:2 intData:0];

}

-(void)close:(NSMutableArray *)inArguments{
    NSString *key =[inArguments objectAtIndex:0];
    EditDialog *edView = [EDDict objectForKey:key];
    if (edView) {
        [edView closeView];
        [edView release];
        [EDDict removeObjectForKey:key];
        [super jsSuccessWithName:@"uexEditDialog.cbClose" opId:[key intValue] dataType:2 intData:0];
        return;
    }
    [super jsSuccessWithName:@"uexEditDialog.cbClose" opId:[key intValue] dataType:2 intData:1];

}

-(void)insert:(NSMutableArray *)inArguments{
    NSString *key =[inArguments objectAtIndex:0];
    EditDialog *edView = [EDDict objectForKey:key];
    if (!edView) {
        [super jsSuccessWithName:@"uexEditDialog.cbInsert" opId:0 dataType:2 intData:1];
        return;
    }
    NSString *str =[inArguments objectAtIndex:1];
    if (str && str.length>0) {
        [edView insertContent:str];
    }
    [super jsSuccessWithName:@"uexEditDialog.cbInsert" opId:0 dataType:2 intData:0];
}

-(void)cleanAll:(NSMutableArray *)inArguments{
    NSString *key =[inArguments objectAtIndex:0];
    EditDialog *edView = [EDDict objectForKey:key];
    if (!edView) {
        [super jsSuccessWithName:@"uexEditDialog.cbCleanAll" opId:0 dataType:2 intData:1];
        return;
    }
    
    [edView cleanAll];
     [super jsSuccessWithName:@"uexEditDialog.cbCleanAll" opId:0 dataType:2 intData:0];
}

-(void)getContent:(NSMutableArray *)inArguments{
    NSString *key =[inArguments objectAtIndex:0];
    EditDialog *edView = [EDDict objectForKey:key];
    if (!edView) {
        [super jsSuccessWithName:@"uexEditDialog.cbGetContent" opId:0 dataType:0 strData:@""];
        return;
    }
    NSString *outStr =[edView getContent];
    [super jsSuccessWithName:@"uexEditDialog.cbGetContent" opId:0 dataType:0 strData:outStr];
}


#pragma mark -
#pragma mark delegate 
-(void)remainTextNum:(int)outNum opId:(NSString *)inOpId{
    EditDialog *edView = [EDDict objectForKey:inOpId];
    if (edView) {
        NSString *jsStr = [NSString stringWithFormat:@"if(uexEditDialog.onNum!=null){uexEditDialog.onNum(%d,\'%d\')}",[inOpId intValue],outNum];
        [meBrwView stringByEvaluatingJavaScriptFromString:jsStr];
    }
    
}
@end
