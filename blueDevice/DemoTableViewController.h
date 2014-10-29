//
// DemoTableViewController.h


#import <Foundation/Foundation.h>
#import "DemoDetailViewController.h"
#import "SerialGATT.h"
@class bluetoothHelper;

@interface DemoTableViewController : UITableViewController<BTSmartSensorDelegate>

@property(strong,nonatomic) SerialGATT *sensor;
@property(nonatomic,retain) NSMutableArray *peripheralViewControllerArray;

@end
