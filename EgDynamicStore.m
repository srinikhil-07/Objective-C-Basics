//
//  EgDynamicStore.m
//  Basics
//
//  Created by sri-7348 on 24/08/18.
//  Copyright © 2018 sri-7348. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#include "EgDynamicStore.h"

@implementation EgDynamicStore:NSObject
    
    -(void) createDynamicStore{
        SCDynamicStoreContext context = {0, NULL, NULL, NULL, NULL};
        
        
        SCDynamicStoreRef ds = SCDynamicStoreCreate(NULL, CFBundleGetIdentifier(CFBundleGetMainBundle()), NULL, &context);
                NSLog(@"Printing the DS ref %@ \n",ds);
        //NSString *key=@"State:/Network/Global/IPv4";
        const CFStringRef keys[3] = {
            CFSTR("State:/Network/Interface/IPv4")
        };
        

        CFArrayRef watchedKeys = CFArrayCreate(kCFAllocatorDefault,
                                               (const void **)keys,
                                               1,
                                               &kCFTypeArrayCallBacks);
        //SCDynamicStoreCallBack(ds,watchedKeys,[self ipChanged);
        if(SCDynamicStoreSetNotificationKeys(ds,NULL, watchedKeys)){
        
        CFRunLoopSourceRef src = SCDynamicStoreCreateRunLoopSource(kCFAllocatorDefault, ds, 0);
        CFRunLoopAddSource([[NSRunLoop currentRunLoop] getCFRunLoop],
                           src,
                           kCFRunLoopCommonModes);
        [[NSRunLoop currentRunLoop] run];
        }else{
            CFRelease(watchedKeys);
            fprintf(stderr, "SCDynamicStoreSetNotificationKeys() failed: %s", SCErrorString(SCError()));
            CFRelease(ds);
            ds = NULL;
            
            return;
        }
    }


@end
