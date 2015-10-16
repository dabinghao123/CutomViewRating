//
//  RateView.m
//  CustomView
//
//  Created by Ray Wenderlich on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RateView.h"

@implementation RateView

@synthesize notSelectedImage = _notSelectedImage;
@synthesize halfSelectedImage = _halfSelectedImage;
@synthesize fullSelectedImage = _fullSelectedImage;
@synthesize rating = _rating;
@synthesize editable = _editable;
@synthesize imageViews = _imageViews;
@synthesize maxRating = _maxRating;
@synthesize midMargin = _midMargin;
@synthesize leftMargin = _leftMargin;
@synthesize minImageSize = _minImageSize;
@synthesize delegate = _delegate;

- (void)baseInit {
    
    _notSelectedImage = nil;
    _halfSelectedImage = nil;
    _fullSelectedImage = nil;
    _rating = 0;
    _editable = NO;    
    _imageViews = [[NSMutableArray alloc] init];
    _maxRating = 5;
    _midMargin = 5;
    _leftMargin = 0;
    _minImageSize = CGSizeMake(5, 5);
    _delegate = nil;    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self baseInit];
    }
    return self;
}

//通过storyboard或者是xib创建时会调用这个方法
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super initWithCoder:aDecoder])) {
        
        [self baseInit];
        
    }
    
    return self;
}

- (void)refresh {
    
//    self.rating = 2.5
    
    for(int i = 0; i < self.imageViews.count; ++i) {
        
        //0--1
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        NSLog(@"====i=%d",i);
        if (self.rating >= i+1) {
            
            imageView.image = self.fullSelectedImage;
            NSLog(@"==rating=1====");

        } else if (self.rating > i) {
            
            NSLog(@"==rating=2====");

            imageView.image = self.halfSelectedImage;
            
        } else {
            NSLog(@"==rating=3====");

            imageView.image = self.notSelectedImage;
            
        }
        
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.notSelectedImage == nil) return;
    
    float desiredImageWidth = (self.frame.size.width - (self.leftMargin*2) - (self.midMargin*self.imageViews.count)) / self.imageViews.count;
    
    float imageWidth = MAX(self.minImageSize.width, desiredImageWidth);
    float imageHeight = MAX(self.minImageSize.height, self.frame.size.height);
    
    for (int i = 0; i < self.imageViews.count; ++i) {
        
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        CGRect imageFrame = CGRectMake(self.leftMargin + i*(self.midMargin+imageWidth), 0, imageWidth, imageHeight);
        imageView.frame = imageFrame;
        
    }
    
    
}

- (void)setMaxRating:(int)maxRating {
    
    _maxRating = maxRating;
    
    // Remove old image views
    for(int i = 0; i < self.imageViews.count; ++i) {
        UIImageView *imageView = (UIImageView *) [self.imageViews objectAtIndex:i];
        [imageView removeFromSuperview];
    }
    
    [self.imageViews removeAllObjects];
    
    // Add new image views
    for(int i = 0; i < maxRating; ++i) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageViews addObject:imageView];
        [self addSubview:imageView];
    }
    
    // Relayout and refresh
    [self setNeedsLayout];
    [self refresh];
}

- (void)setNotSelectedImage:(UIImage *)image {
    _notSelectedImage = image;
    [self refresh];
}

- (void)setHalfSelectedImage:(UIImage *)image {
    _halfSelectedImage = image;
    [self refresh];
}

- (void)setFullSelectedImage:(UIImage *)image {
    _fullSelectedImage = image;
    [self refresh];
}

- (void)setRating:(float)rating {
    _rating = rating;
    [self refresh];
}

- (void)handleTouchAtLocation:(CGPoint)touchLocation {
    
    if (!self.editable) return;
    
    float newRating = 0;
    
    for(int i = self.imageViews.count - 1; i >= 0; i--) {
        
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        
        if (touchLocation.x > CGRectGetMidX(imageView.frame)&&touchLocation.x < CGRectGetMaxX(imageView.frame)){
            
            newRating = i + 1;
        
            NSLog(@"dddddnewRating===handleTouchAtLocation==%f=",newRating);
            
            break;
        }else if(touchLocation.x > CGRectGetMinX(imageView.frame)){
            
            newRating = i + 0.5;
            
            NSLog(@"newRating=i==handleTouchAtLocation===%f=",newRating);

            break;
        }

        
    }
    
    self.rating = newRating;
}

//点击事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.delegate rateView:self ratingDidChange:self.rating];
}

@end
