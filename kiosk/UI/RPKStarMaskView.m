//
//  StarRatingView.m

#import <QuartzCore/QuartzCore.h>
#import "RPKStarMaskView.h"

#import "UIImage+RPK.h"

@interface RPKStarMaskView() <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat maxRating;
@property (nonatomic, assign) CGFloat currentRating;

@end

@implementation RPKStarMaskView

- (instancetype)initWithMaxRating:(CGFloat)maxRating
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
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:NULL];
	tapGesture.numberOfTapsRequired = 1;
	tapGesture.numberOfTouchesRequired = 1;
	tapGesture.delegate = self;
	[self addGestureRecognizer:tapGesture];
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


- (void)setCurrentRating:(CGFloat)currentRating
{
	_currentRating = currentRating;
	
	if ([self.delegate respondsToSelector:@selector(starMaskView:selectStarAtIndex:)]) {
		[self.delegate starMaskView:self selectStarAtIndex:(NSInteger)currentRating];
	}
}

+ (UIColor *)defaultStarTintColor
{
	return [UIColor yellowColor];
}

#pragma mark - Gesture Recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	CGPoint touchPoint = [touch locationInView:self];
	CGFloat starIndex = floor(touchPoint.x / (self.bounds.size.width / self.maxRating));
	[self setCurrentRating:starIndex];
	
	return YES;
}

@end
