//
//  UIPopoverListView.m
//  UIPopoverListViewDemo
//
//  Created by su xinde on 13-3-13.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//

#import "UIPopoverListView.h"
#import <QuartzCore/QuartzCore.h>
#import "DemoDetailViewController.h"
#import "AppDelegate.h"
//#define FRAME_X_INSET 20.0f
//#define FRAME_Y_INSET 40.0f

@interface UIPopoverListView ()

- (void)defalutInit;
- (void)fadeIn;
- (void)fadeOut;

@end

@implementation UIPopoverListView{
@private
    NSArray *texts_;
}
@synthesize navBar;
@synthesize connectState;

@synthesize listView;

//@synthesize sensor;
@synthesize peripheralViewControllerArray;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defalutInit];
    }
    return self;
}

- (void)defalutInit
{
    stateArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waitTheState:) name:@"myNotify" object:nil];
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = TRUE;
    
    titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.font = [UIFont systemFontOfSize:17.0f];
    titleView.backgroundColor = [UIColor colorWithRed:59./255.
                                                 green:89./255.
                                                  blue:152./255.
                                                 alpha:1.0f];
    
    [AppDelegate userInfo].myActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [AppDelegate userInfo].myActivity.hidesWhenStopped = YES;
    
    
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.textColor = [UIColor whiteColor];
    CGFloat xWidth = self.bounds.size.width;
    titleView.lineBreakMode = NSLineBreakByCharWrapping;
    titleView.frame = CGRectMake(0, 0, xWidth, 32.0f);
  //  [self addSubview:_titleView];
    
    
    CGRect tableFrame = CGRectMake(0, 44.0f, xWidth, self.bounds.size.height-32.0f);
    listView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    listView.dataSource = self;
    listView.delegate = self;
    [self addSubview:listView];
    
    navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, xWidth, 44)];
    navBar.barStyle = UIBarStyleBlackOpaque;
    overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    [overlayView addTarget:self
                     action:@selector(dismiss)
           forControlEvents:UIControlEventTouchUpInside];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"设备"];
    [navBar pushNavigationItem:navItem animated:NO];
    [self addSubview:navBar];
    UIBarButtonItem *scanButton = [[UIBarButtonItem alloc] initWithTitle:@"扫描" style:UIBarButtonItemStyleBordered target:self action:@selector(scan:)];
    if (langueNum == 2) {
        [navItem setTitle:@"Device"];
        [scanButton setTitle:@"scan"];
    }
    navItem.leftBarButtonItem = scanButton;
    navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[AppDelegate userInfo].myActivity];
//    if (!sensor) {
//        sensor  = [SerialGATT sharedInstanceMethod];
//        [sensor setup];
//        sensor.delegate = self;
//    }
//    sensor  = [SerialGATT sharedInstanceMethod];
//    [sensor setup];
//    sensor.delegate = self;
    
   // NSLog(@"%@",sensor);
    
    [AppDelegate userInfo].sensor.delegate = self;
    
    peripheralViewControllerArray = [[NSMutableArray alloc] init];
}

-(void)waitTheState:(NSNotification *)value
{
    //connectState = [value object];
   // NSLog(@"connectState=%@",connectState);
    [stateArray removeAllObjects];
    [stateArray addObject:[value object]];
    // [self.listView reloadData];
    [listView reloadData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)scan:(id)sender
{

    if ([[AppDelegate userInfo].sensor activePeripheral]) {
        if ([[AppDelegate userInfo].sensor.activePeripheral isConnected]) {
//            [sensor.managerbluetooth cancelPeripheralConnection:sensor.activePeripheral];
//            sensor.activePeripheral = nil;
            [listView reloadData];
            
            NSLog(@"目前是连接上的");
        }
    }
    else{
    if ([[AppDelegate userInfo].sensor peripherals]) {
        [AppDelegate userInfo].sensor.peripherals = nil;
        [peripheralViewControllerArray removeAllObjects];
        [listView reloadData];
    }
    
    [AppDelegate userInfo].sensor.delegate = self;
    printf("now we are searching device...\n");
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    [[AppDelegate userInfo].sensor findHMSoftPeripherals:5];
    }
  //  [listView reloadData];
}

-(void) scanTimer:(NSTimer *)timer
{
}

#pragma mark - HMSoftSensorDelegate
-(void)sensorReady
{
    //TODO: it seems useless right now.
}

-(void) peripheralFound:(CBPeripheral *)peripheral
{
    DemoDetailViewController *controller = [[DemoDetailViewController alloc] init];
    controller.peripheral = peripheral;
    controller.sensor = [AppDelegate userInfo].sensor;
    [peripheralViewControllerArray addObject:controller];
    [listView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"table代理");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(self.datasource &&
//       [self.datasource respondsToSelector:@selector(popoverListView:numberOfRowsInSection:)])
//    {
//        return [self.datasource popoverListView:self numberOfRowsInSection:section];
//    }
//    
//    return 0;
    NSLog(@"列表有几行");
    NSLog(@"从设备个数=%d",[peripheralViewControllerArray count]);
    if ([[AppDelegate userInfo].sensor.activePeripheral isConnected]) {
        return 1;
    }else{
        return [self.peripheralViewControllerArray count];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath进入");
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    Cell *cell = (Cell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
	
    NSUInteger row = [indexPath row];
    if ([[AppDelegate userInfo].sensor.activePeripheral isConnected]/*&&[peripheralViewControllerArray count]==0*/) {
        //NSLog(@"已经有连接上了");
        cell.devoiceNameLabel.text = [AppDelegate userInfo].sensor.activePeripheral.name;
        cell.connectLabel.text = @"已经连接";
        if (langueNum == 2) {
            cell.connectLabel.text = @"Connected";
        }
    }else{
        DemoDetailViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
        CBPeripheral *peripheral = [controller peripheral];
        cell.devoiceNameLabel.text = peripheral.name;
        if ([stateArray count]>0) {
            cell.connectLabel.text = [stateArray objectAtIndex:0];
        }
        //   cell.connectLabel.text = [stateArray objectAtIndex:0];
       // NSLog(@"此处的%@",connectState);
       // NSLog(@"%@",[peripheralViewControllerArray objectAtIndex:0]);
        //	NSString *text = [self.texts objectAtIndex:[indexPath row]];
        //	[cell.textLabel setText:text];
        //	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	return cell;
}

#pragma mark - UITableViewDelegate



//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(self.delegate &&
//       [self.delegate respondsToSelector:@selector(popoverListView:didSelectIndexPath:)])
//    {
//        [self.delegate popoverListView:self didSelectIndexPath:indexPath];
//    }
//    
//    [self dismiss];
//}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
	
	//DemoDetailViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
	//NSString *text = [self.texts objectAtIndex:[indexPath row]];
	//[detailViewController setText:text];
	
    NSUInteger row = [indexPath row];
    //    bluetoothHelper *controller = [peripheralViewControllerArray objectAtIndex:row];
    if (peripheralViewControllerArray.count != 0 ) {
        DemoDetailViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
        if ([AppDelegate userInfo].sensor.activePeripheral && [AppDelegate userInfo].sensor.activePeripheral != controller.peripheral) {
            [[AppDelegate userInfo].sensor disconnect:[AppDelegate userInfo].sensor.activePeripheral ];
        }
        
        if (![[AppDelegate userInfo].sensor.activePeripheral isConnected]) {
            [AppDelegate userInfo].sensor.activePeripheral = controller.peripheral;
            [[AppDelegate userInfo].sensor connect:[AppDelegate userInfo].sensor.activePeripheral];
            [[AppDelegate userInfo].myActivity startAnimating];
        }
        //    sensor.activePeripheral = controller.peripheral;
        //    [sensor connect:sensor.activePeripheral];
        //    [[AppDelegate userInfo].myActivity startAnimating];
        
        //[self removeFromSuperview];
        [self bringSubviewToFront:controller.view];
    }
    //  [self pushViewController:controller
	//									 animated:YES];
	
}

#pragma mark - animations

- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (void)setTitle:(NSString *)title
{
    titleView.text = title;
}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:overlayView];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}

#define mark - UITouch




//
// draw round rect corner
//
/*
- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, [_fillColor CGColor]);
    CGContextSetStrokeColorWithColor(c, [_borderColor CGColor]);

    CGContextBeginPath(c);
    addRoundedRectToPath(c, rect, 10.0f, 10.0f);
    CGContextFillPath(c);

    CGContextSetLineWidth(c, 1.0f);
    CGContextBeginPath(c);
    addRoundedRectToPath(c, rect, 10.0f, 10.0f);
    CGContextStrokePath(c);
}


static void addRoundedRectToPath(CGContextRef context, CGRect rect,
								 float ovalWidth,float ovalHeight)

{
    float fw, fh;

    if (ovalWidth == 0 || ovalHeight == 0) {// 1
        CGContextAddRect(context, rect);
        return;
    }

    CGContextSaveGState(context);// 2

    CGContextTranslateCTM (context, CGRectGetMinX(rect),// 3
						   CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);// 4
    fw = CGRectGetWidth (rect) / ovalWidth;// 5
    fh = CGRectGetHeight (rect) / ovalHeight;// 6

    CGContextMoveToPoint(context, fw, fh/2); // 7
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);// 8
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);// 9
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);// 10
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // 11
    CGContextClosePath(context);// 12

    CGContextRestoreGState(context);// 13
}
*/
-(void) serialGATTCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    NSLog(@"回送数据");
}

@end
