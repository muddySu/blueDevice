//
//  UIPopoverListView.h
//  UIPopoverListViewDemo
//
//  Created by su xinde on 13-3-13.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DemoDetailViewController.h"
#import "SerialGATT.h"
#import "Cell.h"
@class bluetoothHelper;
@class UIPopoverListView;

@protocol onlystopActivityDelegate <NSObject>

-(void)stopActivity;

@end



@interface UIPopoverListView : UIView <UITableViewDataSource,UITableViewDelegate,BTSmartSensorDelegate>
{
    UITableView *listView;
    UILabel     *titleView;
    UIControl   *overlayView;
    UINavigationBar *navBar;
 
    NSMutableArray *stateArray;
    
    int langueNum;
    
}
@property(nonatomic,strong)NSString *connectState;
//@property(strong,nonatomic)SerialGATT *sensor;
@property(nonatomic,retain) NSMutableArray *peripheralViewControllerArray;


@property(strong,nonatomic)UINavigationBar *navBar;




@property (nonatomic, retain) UITableView *listView;


- (void)show;
- (void)dismiss;



@end
