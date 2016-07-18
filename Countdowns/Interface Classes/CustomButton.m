#import "CustomButton.h"

@implementation CustomButton

- (void)drawRect:(CGRect)rect {
	NSInteger width = [self frame].size.width;
	NSInteger height = [self frame].size.height;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *borderColor, *topColor, *bottomColor, *innerGlow, *selectedTopColor, *selectedBottomColor;
	switch ([[self restorationIdentifier] integerValue]) {
		case 1:
			[self setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.0] forState:UIControlStateNormal];
			[self setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.0] forState:UIControlStateHighlighted];
			borderColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.00];
			topColor = [UIColor colorWithRed:0.47 green:0.47 blue:0.47 alpha:1.00];
			bottomColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00];
			selectedTopColor = [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1.00];
			selectedBottomColor = selectedTopColor;
			innerGlow = [UIColor colorWithWhite:1.0 alpha:0.0];
			break;
		default:
			borderColor = [UIColor colorWithRed:0.77 green:0.43 blue:0.00 alpha:1.00];
			topColor = [UIColor colorWithRed:0.94 green:0.82 blue:0.52 alpha:1.00];
			bottomColor = [UIColor colorWithRed:0.91 green:0.55 blue:0.00 alpha:1.00];
			selectedTopColor = bottomColor;
			selectedBottomColor = topColor;
			innerGlow = [UIColor colorWithWhite:1.0 alpha:0.5];
			break;
	}
	
	NSArray *gradientColors = (@[(id)[topColor CGColor], (id)[bottomColor CGColor]]);
	
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)(gradientColors), NULL);
	
	NSArray *highlightedGradientColors = (@[(id)[selectedTopColor CGColor], (id)[selectedBottomColor CGColor]]);
	
	CGGradientRef highlightedGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)(highlightedGradientColors), NULL);
	
	UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, height) cornerRadius:5];
	[roundedRectanglePath addClip];
	
	CGGradientRef background = self.highlighted ? highlightedGradient : gradient;
	
	CGContextDrawLinearGradient(context, background, CGPointMake(width/2, 0), CGPointMake(width/2, height), 0);
	
	[borderColor setStroke];
	[roundedRectanglePath setLineWidth:2];
	[roundedRectanglePath stroke];
	
	UIBezierPath *innerGlowRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(1.5, 1.5, width-3, height-3) cornerRadius:4];
	[innerGlow setStroke];
	[innerGlowRect setLineWidth:1];
	[innerGlowRect stroke];
	
	CGGradientRelease(gradient);
	CGGradientRelease(highlightedGradient);
	CGColorSpaceRelease(colorSpace);
}

- (void)setHighlighted:(BOOL)highlighted {
	[self setNeedsDisplay];
	[super setHighlighted:highlighted];
}

@end
