//
//  RPKMenuDataSource.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKMenuDataSource.h"
#import <AppSDK/AppLibExtension.h>

@implementation RPKMenuDataSource

- (void)loadData
{
	//--grabing the selected location
	NSArray *locations = [[self preferenceStorage] allLocations];
	NSString *selectedLocationID = [[self preferenceStorage] loadSelectedLocation];
	Location *selectedLocation = [[locations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"code == %@", selectedLocationID]] firstObject];
	
	NSString *kioskURLString = @"";
	NSString *googleURLString = @"";
	
	if (selectedLocation) {
		kioskURLString = selectedLocation.kioskUrl;
		if ([selectedLocation.sourceUrls count] > 0) {
			SourceUrl *sourceURL = [selectedLocation.sourceUrls firstObject];
			googleURLString = sourceURL.sourceUrl;
		}
	}
	
	NSMutableArray *menuItems = [NSMutableArray array];
	
	//--loading Kiosk
	RPKMenuItem *kioskItem = [[RPKMenuItem alloc] init];
	kioskItem.itemURL = [NSURL URLWithString:kioskURLString];
	kioskItem.imageName = @"icon_quicksurvey.png";
	kioskItem.itemTitle = NSLocalizedString(@"Take a\nQuick Survey", nil);
	kioskItem.isSecured = NO;
	kioskItem.itemType = MenuTypeGeneric;
	[menuItems addObject:kioskItem];
	
	//--loading Google Plus
	if ([googleURLString length] > 0) {
		RPKMenuItem *googlePlusItem = [[RPKMenuItem alloc] init];
		NSString *googleURL = [NSString stringWithFormat:@"%@?review=1", googleURLString];
		NSString *loginURL = [NSString stringWithFormat:@"https://accounts.google.com/ServiceLogin?passive=1209600&continue=%@", [self urlEncodeString:googleURL]];
		googlePlusItem.itemURL = [NSURL URLWithString:loginURL];
		googlePlusItem.imageName = @"icon_gplus.png";
		googlePlusItem.itemTitle = NSLocalizedString(@"Leave a review on Google", nil);
		googlePlusItem.isSecured = YES;
		googlePlusItem.itemType = MenuTypeGoogle;
		
		[menuItems addObject:googlePlusItem];
	}
	
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
