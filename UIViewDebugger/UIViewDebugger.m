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

	#define NOTIFICATION_NAME @"UIViewDebugger_Notification"

#pragma mark - DebugView

@interface DebugView : UIView

	/** Keep track of view we're tracking */
	@property (nonatomic, strong) UIView *referenceView;

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
	}
	return self;
}

/** @brief Override method so we can let the debugger know to clear the selected view */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// Tell debugger to clear selected view
	[[NSNotificationCenter defaultCenter]
		postNotificationName:NOTIFICATION_NAME
		object:nil];
}

/** @brief Override method so allow touches through */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	if ([super pointInside:point withEvent:event]) {
		[[NSNotificationCenter defaultCenter]
			postNotificationName:NOTIFICATION_NAME
			object:self];
	}
	
    // UIView will be "transparent" for touch events if we return NO
    return NO;		// Allow touches through
}


@end


#pragma mark - UIViewDebugger

@interface UIViewDebugger ()

	/** Container for debugViews to keep track of them */
	@property (nonatomic, strong) NSMutableArray *debugViews;

	/** Default background color for debugViews 0x8888FF33 */
	@property (nonatomic, strong) UIColor *defaultBackgroundColor;

	/** Default border color for debugViews 0x0000FF50 */
	@property (nonatomic, strong) UIColor *defaultBorderColor;

	/** Panel to display information about tapped view */
	@property (nonatomic, strong) UITextView *infoPanel;

	/** Keep track of selected view */
	@property (nonatomic, strong) UIView *selectedView;

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
		
		// Info panel
		_infoPanel = [[UITextView alloc] initWithFrame:CGRectMake(
			0, 0, 150, 64
		)];
		_infoPanel.font = [UIFont fontWithName:@"Courier-Bold" size:FONT_SIZE_LABEL];
		_infoPanel.textAlignment = NSTextAlignmentRight;
		_infoPanel.backgroundColor = [self.backgroundColor colorWithAlphaComponent:CGColorGetAlpha(self.backgroundColor.CGColor) + 0.1];
	
		// So you can move it around
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(infoPanelPanned:)];
		pan.delaysTouchesBegan = false;
		[_infoPanel addGestureRecognizer:pan];
		
		// Colors
		_defaultBackgroundColor = [UIColor
			colorWithRed:0.5 green:0.5 blue:1.0 alpha:.2];
		_defaultBorderColor = [UIColor
			colorWithRed:0.0 green:0.0 blue:1.0 alpha:.3];
		_backgroundColor = _defaultBackgroundColor;
		_borderColor = _defaultBorderColor;
		
		// Keeping track of selected view
		_selectedView = nil;
		[[NSNotificationCenter defaultCenter] addObserver:self
			selector:@selector(notificationPosted:)
			name:NOTIFICATION_NAME object:nil];
    }
    return self;
}

/** @brief Cleanup */
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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
		debugView.backgroundColor = self.backgroundColor;
		debugView.layer.borderColor = self.borderColor.CGColor;
	}
}

/** @brief Refresh info panel with new information */
- (void)refreshInfoPanelWithView:(UIView*)view
{
	// Get color so we can highlight the selected view
	UIColor *color = [UIColor colorWithCGColor:self.infoPanel.layer.borderColor];
	self.infoPanel.textColor = color;
	self.infoPanel.backgroundColor = [self.backgroundColor
		colorWithAlphaComponent:
			CGColorGetAlpha(self.backgroundColor.CGColor) + 0.5];
	
	// Reset frame
	CGRect frame = self.infoPanel.frame;
	frame.origin.x = frame.origin.y = 0;
	self.infoPanel.frame = frame;

	// Set text
	frame = view.frame;
	self.infoPanel.text = [NSString stringWithFormat:
		@"origin: (%.2f, %.2f)\nsize: %.2f x %.2f\nsubviews: %i",
		frame.origin.x, frame.origin.y,
		frame.size.width, frame.size.height,
		view.subviews.count];
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

/** @brief When DebugView is tapped */
- (void)notificationPosted:(NSNotification *)note
{
	NSLog(@"notificationPosted: %@", note);

	if (note.object)
	{
		self.selectedView = note.object;
		[self refreshInfoPanelWithView:self.selectedView];
		[self.selectedView addSubview:self.infoPanel];
	}
	else	// No debugview tapped
	{
		[self.infoPanel removeFromSuperview];
		self.selectedView = nil;
	}
}

/** @brief Letting the info panel be moved */
- (void)infoPanelPanned:(UIPanGestureRecognizer *)pan
{
	if (self.selectedView)
	{
		self.infoPanel.center = [pan translationInView:self.selectedView];
	}
}

@end
