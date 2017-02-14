//
//  Copyright (c) 2016 OnCircle Inc. All rights reserved.
//

#import "SegmentAnalytics.h"
#import <React/RCTConvert.h>
#import <Analytics/SEGAnalytics.h>
#import <Foundation/Foundation.h>
#import <segment-appsflyer-ios/SEGAppsFlyerIntegrationFactory.h>

@implementation SegmentAnalytics

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(setup:(NSString*)configKey) {
    SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:configKey];
    SEGAppsFlyerIntegrationFactory *afFactory = [SEGAppsFlyerIntegrationFactory instance];

    configuration.flushAt = 1;
    configuration.recordScreenViews = YES;
    configuration.shouldUseLocationServices = true;
    configuration.trackApplicationLifecycleEvents = YES;

    [configuration use:afFactory];
    [SEGAnalytics setupWithConfiguration:configuration];
}

RCT_EXPORT_METHOD(identify:(NSString*)userId traits:(NSDictionary *)traits) {
    [[SEGAnalytics sharedAnalytics] identify:userId traits:[self toStringDictionary:traits]];
}

RCT_EXPORT_METHOD(track:(NSString*)trackText properties:(NSDictionary *)properties) {
    [[SEGAnalytics sharedAnalytics] track:trackText
                               properties:[self toStringDictionary:properties]];
}

RCT_EXPORT_METHOD(screen:(NSString*)screenName properties:(NSDictionary *)properties) {
    [[SEGAnalytics sharedAnalytics] screen:screenName properties:[self toStringDictionary:properties]];
}

RCT_EXPORT_METHOD(alias:(NSString*)newId) {
    [[SEGAnalytics sharedAnalytics] alias:newId];
}

-(NSMutableDictionary*) toStringDictionary: (NSDictionary *)properties {
    NSMutableDictionary *stringDictionary = [[NSMutableDictionary alloc] init];
    for (NSString* key in [properties allKeys]) {
        if ([[properties objectForKey:key] isKindOfClass:[NSMutableDictionary class]]) {
            id value = [self toStringDictionary:[properties objectForKey:key]];
            [stringDictionary setObject:value forKey:[RCTConvert NSString:key]];
        } else {
            id value = [properties objectForKey:key];
            [stringDictionary setObject:value forKey:[RCTConvert NSString:key]];
        }
    }
    return stringDictionary;
}

@end
