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
	Location *selectedLocation = [[locations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"code == %@", self.selectedLocationID]] firstObject];
	Location *locationData;

	NSString *kioskURLString = @"";
	NSString *googleURLString = @"";
	NSString *carsLocationKey = @"";

	Facet *kioskSources = [self userConfig].kioskSources;
	BOOL googleEnabled = NO;
	for (FacetOption *facetOption in kioskSources.facetOptions) {
		if ([facetOption.value isEqualToString:[MobileCommonConstants SOURCE_ID_GOOGLE]]) {
			googleEnabled = YES;
		}
	}
	
	if (selectedLocation) {
		locationData = selectedLocation;
	} else if ([locations count] == 1) {
		locationData = [locations firstObject];
	}

	if(locationData) {
		kioskURLString = locationData.kioskUrl;
		if ([locationData.sourceUrls count] > 0) {

			// Iterate source urls and get enabled sources.
			for(SourceUrl *sourceUrl in locationData.sourceUrls) {

				// If this is a Google-related source.
				if([sourceUrl.source  isEqual: [MobileCommonConstants SOURCE_GOOGLE_PLACES]]) {
					// If google is enabled (including in the plist)
					if(googleEnabled && [UIApplication rp_googleEnabled]) {
						// Get the Google source url.
						googleURLString = sourceUrl.sourceUrl;
					}
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

		NSString *googleURL = [NSString stringWithFormat:@"%@?review=1", googleURLString];
		NSString *loginURL = [NSString stringWithFormat:@"https://accounts.google.com/ServiceLogin?passive=1209600&continue=%@", [self urlEncodeString:googleURL]];
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

		NSString *carsURL = [NSString stringWithFormat:@"%@/survey?key=%@&type=cars&noReviewSources=y", [UIApplication rp_kioskURLString], carsLocationKey];
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
