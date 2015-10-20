//
//  UIView+enableSubviews.h
//  benkTRADER
//
//  Created by A-Team on 16.06.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DisableSubviews)

- (void) enableSubviews:(BOOL)enable
                  filter:(BOOL (^)(UIView *v))filter;

- (void) enableSubviews:(BOOL)enable
                  ofType:(Class)type;

- (void) enableSubviews:(BOOL)enable
              inTagRange:(NSRange)range;

- (void) enableSubviews:(BOOL)enable
                startTag:(NSInteger)start
                  endTag:(NSInteger)end;

- (void) enableSubviews:(BOOL)enable
                withTags:(NSArray *)tags;

- (void) enableSubviews:(BOOL)enable
                  ofType:(Class)type
              inTagRange:(NSRange)range;

- (void) enableSubviews:(BOOL)enable
                  ofType:(Class)type
                withTags:(NSArray *)tags;

- (void) enableSubviews:(BOOL)enable;

@end
