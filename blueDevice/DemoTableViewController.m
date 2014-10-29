//


#import "DemoTableViewController.h"
#import "DemoDetailViewController.h"

#define kCellIdentifier  @"UITableViewCell"
#define kNavigationTitle @"设备"


@interface DemoTableViewController()

@property (nonatomic, readonly, retain) NSArray *texts;



@end


@implementation DemoTableViewController {
@private
	NSArray *texts_;
}

@synthesize sensor;
@synthesize peripheralViewControllerArray;





#pragma mark -
#pragma mark Property





#pragma mark -





#pragma mark -
#pragma mark UITableViewController


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.peripheralViewControllerArray count];
}


- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:kCellIdentifier] ;
	}
	
    NSUInteger row = [indexPath row];
    DemoDetailViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
    CBPeripheral *peripheral = [controller peripheral];
    cell.textLabel.text = peripheral.name;
    
    
//	NSString *text = [self.texts objectAtIndex:[indexPath row]];
//	[cell.textLabel setText:text];
//	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
	return cell;
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
	
	//DemoDetailViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
	//NSString *text = [self.texts objectAtIndex:[indexPath row]];
	//[detailViewController setText:text];
	
    NSUInteger row = [indexPath row];
//    bluetoothHelper *controller = [peripheralViewControllerArray objectAtIndex:row];
    DemoDetailViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
    if (sensor.activePeripheral && sensor.activePeripheral != controller.peripheral) {
        [sensor disconnect:sensor.activePeripheral];
    }
    
    sensor.activePeripheral = controller.peripheral;
    [sensor connect:sensor.activePeripheral];
    
    [self.navigationController pushViewController:controller
										 animated:YES];
	
}


#pragma mark -
#pragma mark UIViewController


- (void)viewDidLoad {
	[super viewDidLoad];
    
	[self.navigationItem setTitle:kNavigationTitle];
    UIBarButtonItem *scanButton = [[UIBarButtonItem alloc] initWithTitle:@"扫描" style:UIBarButtonItemStyleBordered target:self action:@selector(scan:)];
    self.navigationItem.rightBarButtonItem = scanButton;
    //sensor = [[SerialGATT alloc] init];
    sensor  = [SerialGATT sharedInstanceMethod];
    [sensor setup];
    sensor.delegate = self;
    
    NSLog(@"%@",sensor);
    
    peripheralViewControllerArray = [[NSMutableArray alloc] init];
    
//    if ([sensor activePeripheral]) {
//        if ([sensor.activePeripheral isConnected]) {
//            [sensor.managerbluetooth cancelPeripheralConnection:sensor.activePeripheral];
//            sensor.activePeripheral = nil;
//        }
//    }
//    
//    if ([sensor peripherals]) {
//        sensor.peripherals = nil;
//        [peripheralViewControllerArray removeAllObjects];
//        [self.tableView reloadData];
//    }
//    
//    sensor.delegate = self;
//    printf("now we are searching device...\n");
//    
//    [sensor findHMSoftPeripherals:5];
//    
}

-(void)scan:(id)sender
{
    if ([sensor activePeripheral]) {
        if ([sensor.activePeripheral isConnected]) {
            [sensor.managerbluetooth cancelPeripheralConnection:sensor.activePeripheral];
            sensor.activePeripheral = nil;
        }
    }
    
    if ([sensor peripherals]) {
        sensor.peripherals = nil;
        [peripheralViewControllerArray removeAllObjects];
        [self.tableView reloadData];
    }
    
    sensor.delegate = self;
    printf("now we are searching device...\n");
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    [sensor findHMSoftPeripherals:5];
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
    controller.sensor = sensor;
    [peripheralViewControllerArray addObject:controller];
    [self.tableView reloadData];
}



@end
