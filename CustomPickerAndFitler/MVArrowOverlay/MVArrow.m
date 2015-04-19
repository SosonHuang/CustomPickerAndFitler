/*
 MVArrow.m
 Copyright (c) 2014 Andrea Bizzotto bizz84@gmail.com

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "MVArrow.h"

// Code for circle equation resolution was taken from here:
// http://rosettacode.org/wiki/Circles_of_given_radius_through_two_points
CGFloat distance(CGPoint p1, CGPoint p2)
{
    return sqrtf((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y));
}

BOOL isValid(CGFloat separation, CGFloat radius) {
    return separation > 0.0f && separation <= 2*radius;
}

CGPoint findCentre(CGPoint p1, CGPoint p2, CGFloat radius, CGFloat separation, BOOL clockwise) {
    // points are opposite ends circle with given radius
    if(separation == 2*radius) {
        return CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
    }

    float mirrorDistance = sqrtf(radius * radius - separation * separation / 4);
    float mult = clockwise ? 1.0f : -1.0f;
    return CGPointMake((p1.x+p2.x)/2 + mult * mirrorDistance*(p1.y-p2.y)/separation, (p1.y+p2.y)/2 + mult * mirrorDistance*(p2.x-p1.x)/separation);
}

float findAngle(CGPoint from, CGPoint to) {

    float dy = to.y - from.y;
    float dx = to.x - from.x;
    return atan2f(dy, dx);
}


@interface MVArrow()
@property CGPoint circleCenter;
@property CGFloat radius;
@property BOOL clockwise;
@property float startAngle;
@property float endAngle;

@property CGPoint toPoint;
@end

@implementation MVArrow

- (id)initFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint radius:(CGFloat)radius clockwise:(BOOL)clockwise {

    if (self = [super init]) {

        // Calculate
        CGFloat separation = distance(fromPoint,toPoint);
        if (!isValid(separation, radius))
            radius = 0.5f * separation;

        self.circleCenter = findCentre(fromPoint, toPoint, radius, separation, clockwise);
        self.startAngle = findAngle(self.circleCenter, fromPoint);
        self.endAngle = findAngle(self.circleCenter, toPoint);

        self.toPoint = toPoint;
        self.radius = radius;
        self.clockwise = clockwise;

        self.arrowStrokeColor = [UIColor whiteColor];
        self.arrowLineWidth = 2.0f;
        self.arrowSidesLineLength = 20.0f;
    }
    return self;
}

- (NSArray *)calculateShapeLayers
{
    return [self shapesForArrow];
}

- (NSArray *)shapesForArrow
{
    // Arc
    UIBezierPath *arc = [UIBezierPath bezierPath];
    [arc addArcWithCenter:self.circleCenter radius:self.radius startAngle:self.startAngle endAngle:self.endAngle clockwise:self.clockwise];
    [arc setLineWidth:self.arrowLineWidth];
    CAShapeLayer *arcLayer = [self createShapeLayerWithPath:arc.CGPath];

    // Arrow ends
    float mult = self.clockwise ? 1.0f : -1.0f;
    float arrowAngle = self.endAngle + mult * (float)M_PI_2;

    float leftAngle = arrowAngle - (float)(0.8*M_PI);
    float rightAngle = arrowAngle + (float)(0.8*M_PI);

    CAShapeLayer *leftLayer = [self shapeForLineWithAngle:leftAngle length:self.arrowSidesLineLength];
    CAShapeLayer *rightLayer = [self shapeForLineWithAngle:rightAngle length:self.arrowSidesLineLength];

    return @[arcLayer, leftLayer, rightLayer];
}

- (CAShapeLayer *)shapeForLineWithAngle:(float)angle length:(float)length {

    float dx = cosf(angle) * length;
    float dy = sinf(angle) * length;
    CGPoint arrowEnd = CGPointMake(self.toPoint.x + dx, self.toPoint.y + dy);

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.toPoint.x, self.toPoint.y);
    CGPathAddLineToPoint(path, NULL, arrowEnd.x, arrowEnd.y);

    CAShapeLayer *shapeLayer = [self createShapeLayerWithPath:path];
    return shapeLayer;
}

- (CAShapeLayer *)createShapeLayerWithPath:(CGPathRef)path {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = self.arrowStrokeColor.CGColor;
    shapeLayer.fillColor = self.arrowFillColor.CGColor;
    shapeLayer.lineWidth = self.arrowLineWidth;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path;
    return shapeLayer;
}

@end
