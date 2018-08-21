//
//  DelegatingClass.h
//  Basics
//
//  Created by sri-7348 on 21/08/18.
//  Copyright © 2018 sri-7348. All rights reserved.
//
#import <Foundation/Foundation.h>
#ifndef DelegatingClass_h
#define DelegatingClass_h


#endif /* DelegatingClass_h */
@class DelegatingClass; //class having the delegate
@protocol Delegate<NSObject> //delegate protocol
-(void) delegateTask: (DelegatingClass *) sender;
@end


@interface DelegatingClass: NSObject
    @property (nonatomic,weak) id <Delegate> delegate; //delegate confirms to Delegate protocol
// althougth delegate has no specific class, it can call methods/properties defined in protocol
-(void) someOneDoDelegation;
@end
