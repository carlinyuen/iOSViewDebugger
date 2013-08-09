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

@end
