//
//  RPKMenuDataSource.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKMenuDataSource.h"

@implementation RPKMenuDataSource

- (void)loadData
{
	NSMutableArray *menuItems = [NSMutableArray array];
	
	//--loading Kiosk
	RPKMenuItem *kioskItem = [[RPKMenuItem alloc] init];
	kioskItem.itemURL = [NSURL URLWithString:@"http://qa.reputation.com/kiosk?key=a06326f3414"];
	kioskItem.imageName = @"icon_quicksurvey.png";
	kioskItem.itemTitle = @"Quick Survey";
	kioskItem.isSecured = NO;
	[menuItems addObject:kioskItem];
	
	//--loading Google Plus
	RPKGoogleItem *googlePlusItem = [[RPKGoogleItem alloc] init];
	NSString *googleURL = @"https://plus.google.com/117430950571267154753/about?review=1";
	NSString *loginURL = [NSString stringWithFormat:@"https://accounts.google.com/ServiceLogin?passive=1209600&continue=%@", [self urlEncodeString:googleURL]];
	googlePlusItem.itemURL = [NSURL URLWithString:loginURL];
	googlePlusItem.imageName = @"icon_gplus.png";
	googlePlusItem.itemTitle = @"Google+ Local";
	googlePlusItem.isSecured = YES;
	[menuItems addObject:googlePlusItem];
	
	self.menuItems = menuItems;
}

- (RPKMenuItem *)menuItemAtIndex:(NSInteger)index
{
	return [self.menuItems objectAtIndex:index];
}

- (NSString *)urlEncodeString:(NSString *)originalString
{
	NSString *result = originalString;
	
	static CFStringRef doNotEscapeTheseIllegalCharacters = CFSTR(" "); /* prevent <space> being replaced with %20	*/
	static CFStringRef escapeTheseLegalCharacters = CFSTR("\n\r:/=,!$&'()*+;[]@#?%."); /* Even if these are legal, escape them anyway */
	
	CFStringRef escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																	 (CFStringRef)originalString,
																	 doNotEscapeTheseIllegalCharacters,
																	 escapeTheseLegalCharacters,
																	 kCFStringEncodingUTF8);
	
	if (escapedStr) {
		NSMutableString *mutable = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
		CFRelease(escapedStr);
		[mutable replaceOccurrencesOfString:@" " withString:@"%20" options:0 range:NSMakeRange(0, [mutable length])];
		result = [NSString stringWithString:mutable];
	}

	return result;
}

@end
