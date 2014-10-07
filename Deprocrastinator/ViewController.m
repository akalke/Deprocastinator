//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Amaeya Kalke on 10/6/14.
//  Copyright (c) 2014 Amaeya Kalke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate,  UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *toDoListItem;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *onEdit;
@property NSMutableArray *toDoList;
@property BOOL canEdit;
@property BOOL swiped;
@property (strong, nonatomic) NSIndexPath *myIndexPath;
@property int alertUsed;

//@property (strong, nonatomic) UITableViewCell *cell;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoList = [[NSMutableArray alloc] initWithObjects:@"Buy Groceries", @"Pick Up Dry Cleaning", @"Go to the gym", @"Call mom", nil];
    self.canEdit = NO;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Load tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.toDoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todoCellID" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        cell.showsReorderControl = YES;
    }
    cell.textLabel.text = [self.toDoList objectAtIndex:indexPath.row];

    return cell;
}

//Checkmark
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if(cell.accessoryType == 0){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor grayColor];
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
    }


}

//Delete from view
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.toDoList removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

//Move cells around
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;

}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{

    NSString *rowToMove = self.toDoList[sourceIndexPath.row];
    [self.toDoList removeObjectAtIndex:sourceIndexPath.row];
    [self.toDoList insertObject: rowToMove atIndex:destinationIndexPath.row];
}

#pragma alerts
-(void)showPriorityAlert:(BOOL)swiped{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    alertView.title = @"Set the Priority of Task";
    [alertView addButtonWithTitle:@"Red"];
    [alertView addButtonWithTitle:@"Yellow"];
    [alertView addButtonWithTitle:@"Green"];
    [alertView show];
    self.alertUsed = 1;
}

-(void)showDeleteAlert{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    alertView.title = @"Are you sure you want to delete this task?";
    [alertView addButtonWithTitle:@"Delete"];
    [alertView addButtonWithTitle:@"Cancel"];
    [alertView show];
    self.alertUsed = 2;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    UITableViewCell  *cell = [self.tableView cellForRowAtIndexPath:self.myIndexPath];
    if(self.alertUsed == 1){
        if(cell.textLabel.textColor != [UIColor grayColor]){
            if(buttonIndex == 0){
                cell.textLabel.textColor = [UIColor redColor];
            }
            else if(buttonIndex == 1){
                cell.textLabel.textColor = [UIColor yellowColor];
            }
            else if(buttonIndex == 2){
                cell.textLabel.textColor = [UIColor greenColor];
            }
        }
    }
    else if(self.alertUsed == 2){
        if(buttonIndex == 0){
            [self.tableView setEditing:YES];
        }
        else if(buttonIndex == 1){
            return;
        }
    }
}

#pragma IBActions
- (IBAction)onAddButtonPressed:(id)addItem{
    [self.toDoList addObject:self.toDoListItem.text];
    self.toDoListItem.text = @"";
    [self.tableView reloadData];
}

- (IBAction)onEditPressed:(id)sender {
    if([[[sender titleLabel] text] isEqualToString:@"Edit"]){
        [sender setTitle: @"Done" forState: UIControlStateNormal];
        [self showDeleteAlert];
        [self.tableView setEditing:YES];
    }
    else{
        [sender setTitle: @"Edit" forState: UIControlStateNormal];
        [self.tableView setEditing:NO];
    }
}


- (IBAction)rightSwipePriority:(UISwipeGestureRecognizer *)swipeGesture {
    NSLog(@"Swiped");
    self.swiped = YES;
    [self showPriorityAlert:self.swiped];
    CGPoint point = [swipeGesture locationInView:self.tableView];
    self.myIndexPath = [self.tableView indexPathForRowAtPoint: point];


}

- (IBAction)startEditing:(id)sender {
    self.tableView.editing = YES;
}


@end
