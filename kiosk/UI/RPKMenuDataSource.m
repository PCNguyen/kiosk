//
//  RPKMenuDataSource.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKMenuDataSource.h"

@implementation RPKMenuItem

@end

@implementation RPKMenuDataSource

- (void)loadData
{
	NSMutableArray *menuItems = [NSMutableArray array];
	
	//--loading Kiosk
	RPKMenuItem *kioskItem = [[RPKMenuItem alloc] init];
	kioskItem.itemURL = [NSURL URLWithString:@"http://google.com"];
	kioskItem.imageName = @"icon_reputation.png";
	kioskItem.itemTitle = @"Kiosk Review";
	kioskItem.itemDetail = @"Leave a review for this business on Reputation.com";
	[menuItems addObject:kioskItem];
	
	//--loading Google Plus
	RPKMenuItem *googlePlusItem = [[RPKMenuItem alloc] init];
	NSString *redirectURL = @"https://plus.google.com/_/widget/render/localreview?hl=en&origin=https%3A%2F%2Fplus.google.com&placeid=2221140452266056572&source=lo-pp&jsh=m%3B%2F_%2Fscs%2Fapps-static%2F_%2Fjs%2Fk%3Doz.gapi.en.iBmVlTSSvHg.O%2Fm%3D__features__%2Frt%3Dj%2Fd%3D1%2Ft%3Dzcms%2Frs%3DAGLTcCNDdqzVHtQZOJq6TKMfnKZKIZX46Q#rpctoken=359128756&_methods=onSuccess%2ConCancel%2ConError%2C_ready%2C_close%2C_open%2C_resizeMe%2C_renderstart&id=I3_1418679196082&parent=https%3A%2F%2Fplus.google.com&pfname=";
	NSString *loginURL = [NSString stringWithFormat:@"https://accounts.google.com/ServiceLogin?passive=1209600&continue=%@", [self urlEncodeString:redirectURL]];
	loginURL = [NSString stringWithFormat:@"https://plus.google.com/116752878282870811079/about?review=1"];
	googlePlusItem.itemURL = [NSURL URLWithString:loginURL];
	googlePlusItem.imageName = @"icon_gplus.png";
	googlePlusItem.itemTitle = @"Google Review";
	googlePlusItem.itemDetail = @"Leave a review for this business on Google Plus";
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
