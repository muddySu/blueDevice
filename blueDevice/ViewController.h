//
//  ViewController.h
//  blueDevice
//
//  Created by 苏小龙 on 14-6-21.
//  Copyright (c) 2014年 苏小龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPopoverListView.h"
#import "SerialGATT.h"
@interface ViewController : UIViewController<BTSmartSensorDelegate>
{
    Byte sendBuffer[1];          //发送数据数组；
}
@property(strong,nonatomic)SerialGATT *sensor;

-(void) getCharValueUpdated:(NSString *)UUID value:(NSData *)data;
+(ViewController *)sharedInstanceMethod;

@end
