//
//  StarRatingView.m

#import <QuartzCore/QuartzCore.h>
#import "RPKStarRatingView.h"

#import "UIImage+RPK.h"

@interface RPKStarRatingView()

@property (nonatomic, assign) CGFloat maxRating;
@property (nonatomic, assign) CGFloat currentRating;
@property (nonatomic, strong) CALayer *tintLayer;
@property (nonatomic, strong) CALayer *starLayer;
@property (nonatomic, strong) CALayer *maskLayer;

@end

@implementation RPKStarRatingView

- (id)initWithMaxRating:(CGFloat)maxRating
{
	if (self = [super initWithFrame:CGRectZero]) {
		_maxRating = maxRating;
	}
	
	return self;
}

#pragma mark - Override

- (void)commonInit
{
	[super commonInit];
	
	self.opaque = NO;
	
	_currentRating = 0.0f;
	_starTintColor = [[self class] defaultStarTintColor];
	
	[self.layer addSublayer:self.starLayer];
	[self.layer addSublayer:self.tintLayer];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.starLayer.frame = self.bounds;
	self.maskLayer.frame = self.bounds;
	self.tintLayer.frame = [self currentTintFrame];
}

#pragma mark - Max Rating

- (CALayer *)starLayer
{
	if (!_starLayer) {
		_starLayer = [CALayer layer];
		_starLayer.contents = (__bridge id)[UIImage rpk_bundleImageNamed:@"bg_5_stars.png"].CGImage;
	}
	
	return _starLayer;
}

- (CALayer *)maskLayer
{
	if (!_maskLayer) {
		_maskLayer = [CALayer layer];
		_maskLayer.contents = (__bridge id)[UIImage rpk_bundleImageNamed:@"bg_5_stars.png"].CGImage;
	}
	
	return _maskLayer;
}

#pragma mark - Current Rating

- (CGRect)currentTintFrame
{
	CGRect viewBounds = self.bounds;
	CGFloat fullwidth = viewBounds.size.width;
	CGFloat currentWidth = (self.currentRating / self.maxRating) * fullwidth;
	viewBounds.size.width = currentWidth;
	return viewBounds;
}

- (CALayer *)tintLayer
{
	if (!_tintLayer) {
		_tintLayer = [CALayer layer];
		_tintLayer.mask = self.maskLayer;
		_tintLayer.backgroundColor = self.starTintColor.CGColor;
	}
	
	return _tintLayer;
}

- (void)setCurrentRating:(CGFloat)currentRating
{
	_currentRating = currentRating;
	
	[self layoutSubviews];
}

+ (UIColor *)defaultStarTintColor
{
	return [UIColor yellowColor];
}

@end
