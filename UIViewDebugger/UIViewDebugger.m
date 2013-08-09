/**
	@file	UIViewDebugger.m
	@author	Carlin
	@date	8/9/13
	@brief	iOSViewDebugger
*/
//  Copyright (c) 2013 Carlin. All rights reserved.


#import "UIViewDebugger.h"

#import <QuartzCore/QuartzCore.h>

	#define UI_MARGIN_SMALL 4
	#define UI_MARGIN_MEDIUM 16
	#define UI_MARGIN_LARGE 24

	#define FONT_SIZE_LABEL 9

#pragma mark - DebugView

@interface DebugView : UIView

	/** Keep track of view we're tracking */
	@property (nonatomic, strong) UIView *referenceView;

	/** For extra information */
	@property (nonatomic, strong) UITextView *infoPanel;

	/** Refresh info panel */
	- (void)refreshView;

@end

@implementation DebugView

/** @brief Initialize and setup info panel */
- (id)initWithView:(UIView *)view
{
	CGRect frame = view.frame;
	self = [super initWithFrame:frame];
	if (self)
	{
		// Settings
		_referenceView = view;
		self.layer.borderWidth = 1;
		
		// Info panel
		frame.origin.x = frame.origin.y = 0;
		_infoPanel = [[UITextView alloc] initWithFrame:frame];
		_infoPanel.font = [UIFont fontWithName:@"Courier-Bold" size:FONT_SIZE_LABEL];
		_infoPanel.textAlignment = NSTextAlignmentRight;
		_infoPanel.backgroundColor = [self.backgroundColor colorWithAlphaComponent:CGColorGetAlpha(self.backgroundColor.CGColor) + 0.1];
		
		[self refreshView];
	}
	return self;
}

/** Refresh info panel */
- (void)refreshView
{
	UIColor *color = [UIColor colorWithCGColor:self.layer.borderColor];
	self.infoPanel.textColor = color;
	self.infoPanel.backgroundColor = [self.backgroundColor colorWithAlphaComponent:CGColorGetAlpha(self.backgroundColor.CGColor) + 0.1];
	self.infoPanel.text = [NSString stringWithFormat:
		@"origin: (%.2f, %.2f)\nsize: %.2f x %.2f\nsubviews: %i",
		self.referenceView.frame.origin.x,
		self.referenceView.frame.origin.y,
		self.referenceView.frame.size.width,
		self.referenceView.frame.size.height,
		self.referenceView.subviews.count];
}

/** @brief Override method so we can find out when view is hit, but still allow touches through */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	[self.infoPanel removeFromSuperview];	// Hide info panel
	
	// Show info if tapped
	if (CGRectContainsPoint(self.frame, point)) {
		[self addSubview:self.infoPanel];
	}

    // UIView will be "transparent" for touch events if we return NO
    return NO;		// Allow touches through
}

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
		// Storage
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
	[self createDebugViews:view];
	[self redrawDebugViews];
}

/** @brief Recursive call to go through all subviews and create DebugViews
		to display the view frame and details 
	@param view UIView you want to debug with all its subviews
*/
- (void)createDebugViews:(UIView *)view
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
	DebugView *debugView = [[DebugView alloc] initWithView:view];
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

/** @brief Resets any visual settings on debugViews */
- (void)redrawDebugViews
{
	for (DebugView *debugView in self.debugViews)
	{
		[debugView refreshView];
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
