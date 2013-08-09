/**
	@file	UIViewDebugger.m
	@author	Carlin
	@date	8/9/13
	@brief	iOSViewDebugger
*/
//  Copyright (c) 2013 Carlin. All rights reserved.


#import "UIViewDebugger.h"

#import <QuartzCore/QuartzCore.h>

@interface UIViewDebugger ()

	@property (nonatomic, strong) NSMutableArray *debugViews;

@end

@implementation UIViewDebugger

/** @brief Initialize data-related properties */
- (id)init
{
    self = [super init];
    if (self) {
		_debugViews = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark - Class Functions

/** @brief Recursive call to go through all subviews and create DebugViews
		to display the view frame and details 
	@param view UIView you want to debug with all its subviews
*/
- (void)debugSubviews:(UIView *)view
{
	for (UIView* subview in view.subviews)
	{
		[self displayViewFrame:subview onView:(UIView*)view];
		
		if (subview.subviews.count) {
			[self debugSubviews:subview];
		}
	}
}

/** @brief Creates a debug view to display with the view's frame */
- (void)displayViewFrame:(UIView*)view onView:(UIView*)base
{
	UIView* debugView = [[UIView alloc] initWithFrame:view.frame];
	debugView.backgroundColor = [UIColor colorWithRed:0.5 green:1.0 blue:0.5 alpha:.2];
	debugView.layer.borderColor = [[UIColor colorWithRed:0 green:1 blue:0 alpha:.3] CGColor];
	debugView.layer.borderWidth = 1;
	
	[base addSubview:debugView];
	[self.debugViews addObject:debugView];
}

/** @brief Clears all subviews created for debugging */
- (void)clearDebugViews
{
	for (UIView *view in self.debugViews) {
		[view removeFromSuperview];
	}
	[self.debugViews removeAllObjects];
}

#pragma mark - Data Management


#pragma mark - Utilty Functions


#pragma mark - Delegates


@end
