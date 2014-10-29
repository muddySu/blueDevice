//
//  ViewController.m
//  blueDevice
//
//  Created by 苏小龙 on 14-6-21.
//  Copyright (c) 2014年 苏小龙. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


static ViewController *mycontrol = nil;     //单例模式
@implementation ViewController
@synthesize sensor;


/*-------------单例设计模式---------------*/

+(ViewController *)sharedInstanceMethod
{
    @synchronized(self){
        if ( mycontrol == nil) {
            mycontrol = [[ViewController alloc] init];
        }
    }
    return mycontrol;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(mycontrol == nil)
        {
            mycontrol  = [super allocWithZone:zone];
            return mycontrol;
        }
    }
    return nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationItem setTitle:@"血糖仪"];
    UIBarButtonItem *connectButton = [[UIBarButtonItem alloc] initWithTitle:@"连接" style:UIBarButtonItemStyleBordered target:self action:@selector(connect)];
    self.navigationItem.rightBarButtonItem =connectButton;
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 185, 280, 70)];
    [button setTitle:@"请求数据" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 4.0;
    button.layer.masksToBounds = YES;
    button.backgroundColor = [UIColor colorWithRed:1 green:0.847 blue:0.376 alpha:0.6];
    button.layer.borderColor = [[UIColor whiteColor] CGColor];
    [button addTarget:self action:@selector(sendData) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    
//    UIButton *requestButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 60, 80, 30)];
//    [requestButton setTitle:@"请求数据" forState:UIControlStateNormal];
//    requestButton.backgroundColor = [UIColor lightGrayColor];
//    [requestButton addTarget:self action:@selector(sendData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    sensor = [SerialGATT sharedInstanceMethod];
    sensor.delegate =self;
}

-(void)sendData
{
    NSData *sendData;
    sendBuffer[0]=0x06;
    sendData = [[NSData alloc] initWithBytes:sendBuffer length:5];
    [sensor write:sensor.activePeripheral data:sendData];
    NSLog(@"11");
}

-(void)connect
{
    CGFloat xWidth = self.view.bounds.size.width - 20.0f;
    CGFloat yHeight = 272.0f;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    poplistview.listView.scrollEnabled = TRUE;
    [poplistview show];
}




-(void) getCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    //获取到血糖仪数据
    Byte *aByte = (Byte *)[data bytes];
    for(int i=0;i<[data length];i++)
        
        NSLog(@"data = %0x\n",aByte[i]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
