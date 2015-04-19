//
//  SPGripViewBorderView.m
//
//  Created by Seonghyun Kim on 6/3/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import "SPGripViewBorderView.h"
#import "MVArrow.h"

@implementation SPGripViewBorderView

#define kSPUserResizableViewGlobalInset 5.0
#define kSPUserResizableViewDefaultMinWidth 48.0
#define kSPUserResizableViewDefaultMinHeight 48.0
#define kSPUserResizableViewInteractiveBorderSize 10.0

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Clear background to ensure the content view shows through.
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    
    CGContextAddRect(context, CGRectInset(self.bounds, kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewInteractiveBorderSize/2));

    
    CGContextStrokePath(context);
    CGContextRestoreGState(context);

//   MVArrow *arrow = [[MVArrow alloc] initFromPoint:CGPointMake(14, 26) toPoint:CGPointMake(13, 110) radius:260 clockwise:NO];
//    arrow.arrowStrokeColor = [UIColor blackColor];
//    //arrow.arrowFillColor =[UIColor blackColor];
//    
//    /// First, clear previous layers
//    //[self clearSublayers];
//    // Draw new ones
//    NSArray *layers = [arrow calculateShapeLayers];
//    for (CAShapeLayer *layer in layers) {
//        [self.layer addSublayer:layer];
//    }
//
//    
//    MVArrow *arrow2 = [[MVArrow alloc] initFromPoint:CGPointMake(150, 120) toPoint:CGPointMake(150, 44) radius:260 clockwise:NO];
//    arrow2.arrowStrokeColor = [UIColor blackColor];
//    //arrow.arrowFillColor =[UIColor blackColor];
//    
//    // First, clear previous layers
//   // [self clearSublayers2];
//    // Draw new ones
//    NSArray *layers2 = [arrow2 calculateShapeLayers];
//    for (CAShapeLayer *layer in layers2) {
//        [self.layer addSublayer:layer];
//    }

    //画虚线
    //    CGContextSetLineWidth(context, 5.0);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//    
//    CGFloat dashArray[] = {2,6,4,2};
//    
//    CGContextSetLineDash(context, 3, dashArray, 4);//跳过3个再画虚线，所以刚开始有6-（3-2）=5个虚点
//    
//    CGContextMoveToPoint(context, 10, 200);
//    
//    CGContextAddQuadCurveToPoint(context, 150, 10, 300, 200);

    
    
    
    
//    CGContextSetRGBStrokeColor(context,1,0,0,1);
//    CGContextMoveToPoint(context,150,50);
//    CGContextAddLineToPoint(context,100,80);
//    CGContextAddLineToPoint(context,130,150);
//    CGContextMoveToPoint(context,150,50);//圆弧的起始点
//    CGContextAddArcToPoint(context,100,80,130,150,50);
//    CGContextStrokePath(context);
    
    
    //CGPointMake(14, 26) toPoint:CGPointMake(13, 110) radius:260 clockwise:NO];

    
//    CGContextSetLineWidth(context, 2.0);
//    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
//    CGContextMoveToPoint(context, 30, 30);
//    CGContextAddArcToPoint(context, 14,106, 23,150, 100);
//    CGContextStrokePath(context);
}


//- (void)clearSublayers {
//    
//    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
//}
- (void)clearSublayers2 {
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}
@end
