/*
 MVArrowOverlayView.m
 Copyright (c) 2014 Andrea Bizzotto bizz84@gmail.com

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "MVArrowOverlayView.h"
#import "MVArrow.h"

@interface MVArrowOverlayView ()
@property MVArrow *arrow;
@end

@implementation MVArrowOverlayView

- (void)awakeFromNib
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self addGestureRecognizer:tapGestureRecognizer];

    self.activeClearColor = [UIColor whiteColor];
    self.inactiveClearColor = [UIColor whiteColor];
}

- (void)drawFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint radius:(CGFloat)radius clockwise:(BOOL)clockwise {

    self.arrow = [[MVArrow alloc] initFromPoint:fromPoint toPoint:toPoint radius:radius clockwise:clockwise];
    self.arrow.arrowStrokeColor = self.arrowStrokeColor;
    self.arrow.arrowFillColor = self.activeClearColor;

    // First, clear previous layers
    [self clearSublayers];
    // Draw new ones
    NSArray *layers = [self.arrow calculateShapeLayers];
    for (CAShapeLayer *layer in layers) {
        [self.layer addSublayer:layer];
    }
}

- (void)clear {
    self.arrow = nil;
    [self clearSublayers];
}

- (void)clearSublayers {

    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

- (void)setArrowStrokeColor:(UIColor *)arrowStrokeColor
{
    _arrowStrokeColor = arrowStrokeColor;
    if (self.arrow) {
        self.arrow.arrowStrokeColor = arrowStrokeColor;
    }
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    //Code to handle the gesture
    CGPoint location = [recognizer locationInView:recognizer.view];

    if ([self.delegate respondsToSelector:@selector(tappedAtPosition:)])
        [self.delegate tappedAtPosition:location];
}

@end
