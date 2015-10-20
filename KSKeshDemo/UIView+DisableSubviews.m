//
//  UIView+enableSubviews.m
//  benkTRADER
//
//  Created by A-Team on 16.06.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import "UIView+DisableSubviews.h"

@implementation UIView (DisableSubviews)

- (void) enableSubviews:(BOOL)enable filter:(BOOL (^)(UIView *v))filter {
    if (!filter) {
        filter = ^BOOL (UIView *v) { return YES; };
    }
    
    for (id v in self.subviews) {
        [v enableSubviews:enable filter:filter];
        if (filter(v) && [v respondsToSelector:@selector(setEnabled:)]) {
            [v setEnabled:enable];
        }
    }
}

- (void) enableSubviews:(BOOL)enable ofType:(Class)type {
    [self enableSubviews:enable
                   filter:^BOOL (UIView *v) {
                       return [v isKindOfClass:type];
                   }];
}

- (void) enableSubviews:(BOOL)enable inTagRange:(NSRange)range {
    [self enableSubviews:enable
                   filter:^BOOL (UIView *v) {
                       return NSLocationInRange(v.tag, range);
                   }];
}

- (void) enableSubviews:(BOOL)enable startTag:(NSInteger)start endTag:(NSInteger)end {
    [self enableSubviews:enable
               inTagRange:NSMakeRange(start, (end - start + 1))];
}

- (void) enableSubviews:(BOOL)enable withTags:(NSArray *)tags {
    [self enableSubviews:enable
                   filter:^BOOL (UIView *v) {
                       return [tags containsObject:[NSNumber numberWithInteger:v.tag]];
                   }];
}

- (void) enableSubviews:(BOOL)enable ofType:(Class)type inTagRange:(NSRange)range {
    [self enableSubviews:enable
                   filter:^BOOL (UIView *v) {
                       return [v isKindOfClass:type] && NSLocationInRange(v.tag, range);
                   }];
}

- (void) enableSubviews:(BOOL)enable ofType:(Class)type withTags:(NSArray *)tags {
    [self enableSubviews:enable
                   filter:^BOOL (UIView *v) {
                       return [v isKindOfClass:type] &&
                       [tags containsObject:[NSNumber numberWithInteger:v.tag]];
                   }];
}

- (void) enableSubviews:(BOOL)enable {
    [self enableSubviews:enable filter:nil];
}

@end
