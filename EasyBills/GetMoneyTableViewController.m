//
//  GetMoneyTableViewController.m
//  我的账本
//
//  Created by 罗 杰 on 14-9-7.
//  Copyright (c) 2014年 罗 杰. All rights reserved.
//

#import "GetMoneyTableViewController.h"
#import "AFTextView.h"
#import <CoreData/CoreData.h>
#import "moneyTableViewCell.h"
#import "KindTableViewCell.h"
#import "DateTableViewCell.h"
#import "NoteTableViewCell.h"
#import "Bill+Create.h"
#import "PubicVariable.h"
#import "PubicVariable+FetchRequest.h"
#import <CoreLocation/CoreLocation.h>
#import "Kind+Create.h"


@interface GetMoneyTableViewController () <CLLocationManagerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *kindTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (strong, nonatomic) IBOutlet AFTextView *noteTextView;

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) CLLocation *cuurentLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) UIDatePicker *datePicker;


@property (strong, nonatomic) UIToolbar *keyboardToolBar;

@end

@implementation GetMoneyTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self updateUI];
    [self configBarButtonItem];

    //NSLog(@"isincome: %i", self.bill.isincome.boolValue);
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.barTintColor = self.isIncome ? PNGreen : PNRed ;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self textFieldDidEndEditing:self.moneyTextField];
    [PubicVariable saveContext];
    
}


-(void)updateUI
{
    self.title = self.isIncome ? @"收入": @"支出";
    [self configMoneyCell];
    [self configKindCell];
    [self configDateCell];
    [self configNoteCell];
    
}


-(void)configMoneyCell
{
    self.moneyTextField.text = self.bill  ? [NSString stringWithFormat:@"%d",abs(self.bill.money.floatValue)] :  @"200";
    self.moneyTextField.delegate = self;

}

-(void)configKindCell
{
    
    self.fetchedResultsController =[Kind fetchedResultsControllerIsincome:self.isIncome];
    
    Kind *kind = self.bill ? self.bill.kind : [Kind lastVisiteKindIsIncome:self.isIncome];
    self.kindTextField.text = kind.name;
    
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:kind];
    self.pickerView = [[UIPickerView  alloc] initWithFrame:CGRectZero];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.pickerView selectRow:indexPath.item inComponent:indexPath.section animated:NO];
    self.pickerView.showsSelectionIndicator = YES;
    self.kindTextField.inputView = self.pickerView;
    self.kindTextField.delegate = self;

}

-(void)configDateCell
{
    NSDate *date = self.bill ? self.bill.date : [NSDate date];
    self.dateTextField.text = [PubicVariable stringFromDate:date];
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    self.datePicker.date = date;
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self
                        action:@selector(datePickerChanged:)
              forControlEvents:UIControlEventValueChanged];
    self.dateTextField.inputView = _datePicker;
    self.dateTextField.delegate = self;

}

-(void)configNoteCell
{
    NSString *note = self.bill ? self.bill.note : nil;
    self.noteTextView.font =[UIFont systemFontOfSize:17.0];
    self.noteTextView.text = note;
    self.noteTextView.placeholder = @"特别说明...";
    self.noteTextView.textColor = PNFreshGreen;
    self.noteTextView.inputAccessoryView = self.keyboardToolBar;
    self.noteTextView.delegate = self;
}

-(void)configBarButtonItem
{
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(cancel:)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(done:)];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}

- (IBAction)canGetLocation:(UISwitch *)sender {
    if (sender.isOn) {
        [self getCurentLocation];
    }else{
        self.cuurentLocation = nil;
    }
}

-(void)getCurentLocation
{
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

-(CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];

    }
    return _locationManager;
}


#pragma mark - CLLocationManagerDelegate

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                    message:@"无法获取您的位置"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles: nil];
    [Alert show];
}



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.cuurentLocation = locations.lastObject;
    [manager stopUpdatingLocation];
    NSLog(@"latitude:%f longitude:%f",self.cuurentLocation.coordinate.latitude ,self.cuurentLocation.coordinate.longitude);

}

- (IBAction)done:(UIBarButtonItem *)sender
{
    BOOL canFinish = YES;
    
    if ([self.moneyTextField.text isEqualToString:@""] || [self.moneyTextField.text isEqualToString:@"0"]) {
        canFinish = NO;
        self.moneyLabel.textColor = [UIColor redColor];
    }
    
    if (canFinish) {
        self.moneyLabel.textColor = [UIColor blackColor];

        
        Bill *bill = self.bill ? self.bill : [Bill billIsIncome:self.isIncome];

        float sum = self.moneyTextField.text.floatValue;
        NSLog(@"sum:  %f",sum);
        
        if (!self.isIncome) sum = sum * -1;
        NSNumber *sumNumber =[NSNumber numberWithFloat: sum];
        if (![bill.money isEqualToNumber:sumNumber]) bill.money = sumNumber;
        
        NSLog(@"text:  %@",self.moneyTextField.text);
        

        Kind *kind = [Kind kindWithName:self.kindTextField.text isIncome:self.isIncome];
        bill.kind = kind;
        
        
        bill.date= [self.datePicker date];
        bill.dayID =[PubicVariable dayIDWithDate:bill.date];
        bill.weekID = [PubicVariable weekIDWithDate:bill.date];
        bill.monthID = [PubicVariable monthIDWithDate:bill.date];
        bill.weekday = [PubicVariable weekdayWithDate:bill.date];
        bill.weekOfMonth = [PubicVariable weekOfMonthWithDate:bill.date];
        bill.month = [PubicVariable monthWithDate:bill.date];
        
        
        
        NSLog(@"BillWeekID = %@",bill.weekID);
        if (self.cuurentLocation) {
            bill.latitude = [NSNumber numberWithDouble:self.cuurentLocation.coordinate.latitude];
            bill.longitude = [NSNumber numberWithDouble:self.cuurentLocation.coordinate.longitude];
            //NSLog(@"latitude:%f longitude:%f",bill.latitude.floatValue ,bill.longitude.floatValue);

        }else{
            bill.latitude = nil;
            bill.longitude = nil;
        }
        
        
        
        bill.note = self.noteTextView.text;
        
        
        [self dismissViewControllerAnimated:YES completion:^(){}];
    }
    

}

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:^(){}];

}

- (void)deleteBill
{
    [[PubicVariable managedObjectContext] deleteObject:self.bill];
    [self dismissViewControllerAnimated:YES completion:^(){}];
    
}

-(void)setBill:(Bill *)bill
{
    _bill = bill;
    self.isIncome = bill.isIncome.boolValue;
    [self updateUI];
}

/*
-(void)setIsIncome:(BOOL)isIncome
{
    _isIncome = isIncome;
    self.navigationController.navigationBar.barTintColor = isIncome ? PNGreen : PNRed ;
    
}
 */

-(UIToolbar *)keyboardToolBar
{
    if (!_keyboardToolBar) {
        _keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
        
        _keyboardToolBar.barStyle = UIBarStyleDefault;
        UIBarButtonItem *previousBarButton =[[UIBarButtonItem alloc] initWithTitle:@"前一项" style:UIBarButtonItemStyleBordered target:self action:@selector(previousTextField)];
        UIBarButtonItem *nextBarButton =[[UIBarButtonItem alloc] initWithTitle:@"后一项" style:UIBarButtonItemStyleBordered target:self action:@selector(nextTextField)];
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *doneBarButton =[[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleBordered target:self action:@selector(resignKeyboard)];
        previousBarButton.tintColor = [UIColor blackColor];
        nextBarButton.tintColor = [UIColor blackColor];
        doneBarButton.tintColor = [UIColor blackColor];
        
        [_keyboardToolBar setItems:[NSArray arrayWithObjects:
                                    previousBarButton,
                                    nextBarButton,
                                    flex,
                                    doneBarButton,
                                    nil]];
        
        
    }
    return _keyboardToolBar;
}



-(void)previousTextField
{
    
}
-(void)nextTextField
{
    
}
-(void)resignKeyboard
{
    [self.view endEditing:YES];
}


/*
 
 -(BOOL)textFieldShouldReturn:(UITextField *)textField
 {
 [textField resignFirstResponder];
 return YES;
 }
 
 
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    float sum = textField.text.floatValue;
    return sum == 0 ? NO : YES;
}
*/
#pragma mark UITextView Delegate Methods
-(void)textViewDidBeginEditing:(UITextView *)textView
{
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
}



#pragma mark UIDatePicker Methods

-(IBAction)datePickerChanged:(id)sender
{
    
    self.dateTextField.text = [PubicVariable stringFromDate:[self.datePicker date]];
}
#pragma mark UIPickerViewDataSource Methods
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //NSLog(@"section:  %lu",(unsigned long)[[self.fetchedResultsController sections] count]);
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //NSLog(@"row:  %lu",(unsigned long)[[[self.fetchedResultsController sections] objectAtIndex:component] numberOfObjects]);
    return [[[self.fetchedResultsController sections] objectAtIndex:component] numberOfObjects];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger sectionsCount = [super numberOfSectionsInTableView:tableView];
    return self.bill?  sectionsCount : sectionsCount - 1;
}
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"delete"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:@"删除"
                                                        otherButtonTitles: nil];
        [actionSheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"删除" ]) {
        [self deleteBill];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
