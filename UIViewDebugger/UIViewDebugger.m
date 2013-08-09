/**
	@file	UIViewDebugger.m
	@author	Carlin
	@date	8/9/13
	@brief	iOSViewDebugger
*/
//  Copyright (c) 2013 Carlin. All rights reserved.


#import "UIViewDebugger.h"

#import <QuartzCore/QuartzCore.h>


#pragma mark - DebugView

@interface DebugView : UIView

@end

@implementation DebugView


@end


#pragma mark - UIViewDebugger

@interface UIViewDebugger ()

	/** @brief Container for debugViews to keep track of them */
	@property (nonatomic, strong) NSMutableArray *debugViews;

	/** Default background color for debugViews 0x8888FF33 */
	@property (nonatomic, strong) UIColor *defaultBackgroundColor;

	/** Default border color for debugViews 0x0000FF50 */
	@property (nonatomic, strong) UIColor *defaultBorderColor;

@end

@implementation UIViewDebugger

/** @brief Initialize data-related properties */
- (id)init
{
    self = [super init];
    if (self)
	{
		_debugViews = [[NSMutableArray alloc] init];
		
		// Colors
		_defaultBackgroundColor = [UIColor
			colorWithRed:0.5 green:0.5 blue:1.0 alpha:.2];
		_defaultBorderColor = [UIColor
			colorWithRed:0.0 green:0.0 blue:1.0 alpha:.3];
		_backgroundColor = _defaultBackgroundColor;
		_borderColor = _defaultBorderColor;
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
		[self addDebugView:subview onView:(UIView*)view];
		
		if (subview.subviews.count) {
			[self debugSubviews:subview];
		}
	}
}

/** @brief Creates a debug view to display with the view's frame */
- (void)addDebugView:(UIView*)view onView:(UIView*)base
{
	UIView* debugView = [[UIView alloc] initWithFrame:view.frame];
	debugView.backgroundColor = self.backgroundColor;
	debugView.layer.borderColor = self.borderColor.CGColor;
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

/** @brief Resets any settings on debugViews */
- (void)redrawDebugViews
{
	for (DebugView *debugView in self.debugViews) {
		debugView.backgroundColor = self.backgroundColor;
		debugView.layer.borderColor = self.borderColor.CGColor;
	}
}


#pragma mark - Data Management

/** @brief When user changes background color, need to refresh all debugViews */
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
	_backgroundColor = (backgroundColor)
		? backgroundColor : self.defaultBackgroundColor;
		
	[self redrawDebugViews];
}

/** @brief When user changes border color, need to refresh all debugViews */
- (void)setBorderColor:(UIColor *)borderColor
{
	_borderColor = (borderColor)
		? borderColor : self.defaultBorderColor;
		
	[self redrawDebugViews];
}


#pragma mark - Utilty Functions


#pragma mark - Delegates


@end
