/**
	@file	UIViewDebugger.h
	@author	Carlin
	@date	8/9/13
	@brief	iOSViewDebugger
*/
//  Copyright (c) 2013 Carlin. All rights reserved.


#import <Foundation/Foundation.h>

@interface UIViewDebugger : NSObject

	/** Background color for debugViews, default is 0x8888FF33 */
	@property (nonatomic, strong) UIColor *backgroundColor;

	/** Border color for debugViews, default is 0x0000FF50 */
	@property (nonatomic, strong) UIColor *borderColor;

	/** @brief Recursive call to go through all subviews and create DebugViews
			to display the view frame and details
		@param view UIView you want to debug with all its subviews
	*/
	- (void)debugSubviews:(UIView *)view;

	/** @brief Clears all subviews created for debugging */
	- (void)clearDebugViews;

@end
