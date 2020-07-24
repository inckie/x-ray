//
//  ReactNativeModulesExports.m
//  QuickBrickApple
//
//  Created by François Roland on 20/11/2018.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

@import React;

@interface RCT_EXTERN_MODULE (XRayLoggerBridge, NSObject)

RCT_EXTERN_METHOD(logEvent:(NSDictionary *)eventData);

@end
