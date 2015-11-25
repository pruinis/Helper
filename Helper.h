//
//  Helper.h
//
//  Created by Anton Morozov on 02.12.13.
//  Copyright (c) 2013 Anton Morozov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Helper : NSObject

+ (id)sharedHelper;

// Location
+(BOOL)isLocationServicesEnabled;
+(BOOL)isLocationServicesAuthorized;

+(NSInteger)getOffset;

// address
+(NSString*)makeAddressStringFromPlacemark:(MKPlacemark*)placemark;

// Orientation
+(int)exifOrientationFromDeviceOrientation:(UIDeviceOrientation)deviceOrientation andUsingFrontFacingCamera:(BOOL)isUsingFrontFacingCamera;
+ (UIImageOrientation)currentImageOrientation;
+ (UIImageOrientation) exifOrientationToiOSOrientation:(int)exifOrientation;
+ (int)imageOrientationToExifOrientation:(UIImageOrientation)imageOrientation;

// app state
+ (BOOL)isAppInBackground;

+ (BOOL)isMetricMeasureSystem;

// Pars dicts
NSString *getStringFromKey(id key, NSDictionary *dict);
NSDictionary *getDictionaryFromKey(id key, NSDictionary *dict);
BOOL isObjectIsDictionary(id obj);

// Pars array
NSArray *getArrayFromKey(id key, NSDictionary *dict);

// Pars number
NSNumber *getNumberFromKey(id key, NSDictionary *dict);

@end
