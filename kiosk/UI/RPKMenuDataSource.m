//
//  RPKMenuDataSource.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKMenuDataSource.h"
#import "UIApplication+RP.h"
#import "MobileCommon.h"

#import <AppSDK/AppLibExtension.h>

@implementation RPKMenuDataSource

- (void)configureNonBindingProperty
{
	[self ignoreUpdateProperty:@selector(selectedLocationID)];
}

- (void)loadData
{
	//--grabing the selected location
	NSArray *locations = [[self preferenceStorage] allLocations];

	self.selectedLocationID = [[self preferenceStorage] loadSelectedLocation];
	NSString *googleSourceId = [[self preferenceStorage] getGoogleSourceId];

	Location *selectedLocation = [[locations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"code == %@", self.selectedLocationID]] firstObject];
	Location *locationData;

	NSString *kioskURLString = @"";
	NSString *googleURLString = @"";
	NSString *carsLocationKey = @"";

	if (selectedLocation) {
		locationData = selectedLocation;
	} else if ([locations count] == 1) {
		locationData = [locations firstObject];
	}
    NSLog(@"locations %@", locationData);
	if(locationData) {
		kioskURLString = locationData.kioskUrl;
		if ([locationData.sourceUrls count] > 0) {

			// Iterate source urls and get enabled sources.
			for(SourceUrl *sourceUrl in locationData.sourceUrls) {

				// If this is a Google-related source.
				if([googleSourceId length] > 0 && [sourceUrl.source  isEqual: googleSourceId] && sourceUrl.isKioskReviewable && !sourceUrl.isCompetitor) {
					// Get the Google source url.
					googleURLString = sourceUrl.sourceUrl;
				}

				// If this is a Cars.com source.
				if([sourceUrl.source  isEqual: [MobileCommonConstants SOURCE_CARS]]) {
					// Cars.com is enabled.
					carsLocationKey = locationData.locationKey;
				}

			}
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
        
       // NSLog(@"google url %@", locationData.sourceUrls);

		NSString *googleURL = [NSString stringWithFormat:@"%@?review=1", @"https://www.google.com/search?q=Amami%20Sushi%2C%201789%20El%20Camino%20Real%2C%20San%20Bruno%2C%20CA%2094066&ludocid=9429747110387290923&rlst=n&ved=1t%3A10503&ei=JnpfVtefE8qW0gS0wbnIBw&hl=en-US#lrd=0x808f7779ed90be7d:0x82dd31093466932b,2"];
		NSString *loginURL = [NSString stringWithFormat:@"https://accounts.google.com/ServiceLogin?passive=1209600&continue=%@", [self urlEncodeString:googleURL]];
        googlePlusItem.redirectURL = [NSURL URLWithString:googleURL];
		googlePlusItem.itemURL = [NSURL URLWithString:loginURL];
		googlePlusItem.imageName = @"icon_gplus.png";
		googlePlusItem.itemTitle = NSLocalizedString(@"Leave a review on Google", nil);
		googlePlusItem.isSecured = YES;
		googlePlusItem.itemType = MenuTypeGoogle;
		
		[menuItems addObject:googlePlusItem];
	}
	
	//--loading Cars
	if ([carsLocationKey length] > 0) {
		RPKMenuItem *carsItem = [[RPKMenuItem alloc] init];

		NSString *carsURL = [NSString stringWithFormat:@"%@/survey?key=%@&type=cars&isFromKioskTablet", [UIApplication rp_kioskURLString], carsLocationKey];
		carsItem.itemURL = [NSURL URLWithString:carsURL];
		carsItem.imageName = @"icon_large_cars.png";
		carsItem.itemTitle = NSLocalizedString(@"Take a\nCars Survey", nil);
		carsItem.isSecured = NO;
		carsItem.itemType = MenuTypeGeneric;
		[menuItems addObject:carsItem];
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
	
	static CFStringRef doNotEscapeTheseIllegalCharacters = CFSTR(" "); /* prevent <space> being replaced with %20   */
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
