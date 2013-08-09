//
//  ViewController.m
//  iOSViewDebugger
//
//  Created by Carlin on 8/9/13.
//  Copyright (c) 2013 Carlin. All rights reserved.
//

#import "ViewController.h"

#import "UIViewDebugger.h"

@interface ViewController ()

	@property (nonatomic, strong) UIViewDebugger *debugger;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.debugger = [[UIViewDebugger alloc] init];
	[self.debugger debugSubviews:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	NSString *cellID = @"Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
	
	cell.textLabel.text = [NSString stringWithFormat:@"Row %i", indexPath.row];
	
    return cell;
}


@end
