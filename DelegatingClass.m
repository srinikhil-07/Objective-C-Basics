//
//  DelegatingClass.m
//  Basics
//
//  Created by sri-7348 on 21/08/18.
//  Copyright © 2018 sri-7348. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DelegatingClass.h"

@implementation DelegatingClass
@synthesize delegate;

-(void) someOneDoDelegation{
    [self.delegate delegateTask: self];
}
@end
