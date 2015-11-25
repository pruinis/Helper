//
//  Helper.m
//
//  Created by Anton Morozov on 02.12.13.
//  Copyright (c) 2013 Anton Morozov. All rights reserved.
//

#import "Helper.h"

@implementation Helper

#pragma mark -
#pragma mark - Location

+ (id)sharedHelper {
    static Helper *sharedSessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSessionManager = [[self alloc] init];
    });
    return sharedSessionManager;
}

+(BOOL)isLocationServicesEnabled
{
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        return YES;
    } else {
        return NO;
    }
}

+(BOOL)isLocationServicesAuthorized
{
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
    {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -
#pragma mark - About device

+(NSInteger)getOffset
{
    return  - [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];
}

#pragma mark -
#pragma mark - Address placemark

+(NSString *)makeAddressStringFromPlacemark:(MKPlacemark *)placemark
{
    NSMutableString *addressStr = [NSMutableString string];
    
    if ([placemark.name length]) {
        [addressStr appendString:placemark.name];
    }
    
    if ([placemark.thoroughfare length]) {
        if ([addressStr length]){
            [addressStr appendFormat:@", %@",placemark.thoroughfare];
        } else {
            [addressStr appendString:placemark.thoroughfare];
        }
    }
    
    if ([placemark.locality length]) {
        if ([addressStr length]){
            [addressStr appendFormat:@", %@",placemark.locality];
        } else {
            [addressStr appendString:placemark.locality];
        }
    }
    
    if ([placemark.subLocality length]) {
        if ([addressStr length]){
            [addressStr appendFormat:@", %@",placemark.subLocality];
        } else {
            [addressStr appendString:placemark.subLocality];
        }
    }
    
    if ([placemark.administrativeArea length]) {
        if ([addressStr length]){
            [addressStr appendFormat:@", %@",placemark.administrativeArea];
        } else {
            [addressStr appendString:placemark.administrativeArea];
        }
    }
    
    
    if ([placemark.subAdministrativeArea length]) {
        if ([addressStr length]){
            [addressStr appendFormat:@", %@",placemark.subAdministrativeArea];
        } else {
            [addressStr appendString:placemark.subAdministrativeArea];
        }
    }
    
    if ([placemark.postalCode length]) {
        if ([addressStr length]){
            [addressStr appendFormat:@", %@",placemark.postalCode];
        } else {
            [addressStr appendString:placemark.postalCode];
        }
    }
    
    if ([placemark.country length]) {
        if ([addressStr length]){
            [addressStr appendFormat:@", %@",placemark.country];
        } else {
            [addressStr appendString:placemark.country];
        }
    }

    return addressStr;
}

#pragma mark -
#pragma mark - Orientation

+(int)exifOrientationFromDeviceOrientation:(UIDeviceOrientation)deviceOrientation andUsingFrontFacingCamera:(BOOL)isUsingFrontFacingCamera
{
    enum {
		PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
		PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.
		PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.
		PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.
		PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.
		PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.
		PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.
		PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.
	};
    
    int exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
	
	switch (deviceOrientation) {
		case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
			exifOrientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
			break;
		case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
			if (isUsingFrontFacingCamera)
				exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
			else
				exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
			break;
		case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
			if (isUsingFrontFacingCamera)
				exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
			else
				exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
			break;
		case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
		default:
			exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
			break;
    }
    
    return exifOrientation;
}

+ (UIImageOrientation)currentImageOrientation {
    // This is weird, but it works
    // By all means fix it, but make sure to test it afterwards
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    UIImageOrientation imageOrientation = UIImageOrientationRight;
    
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            imageOrientation = UIImageOrientationUp;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            imageOrientation = UIImageOrientationDown;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            imageOrientation = UIImageOrientationLeft;
            break;
            
        default:
            break;
    }
    
    return imageOrientation;
}

// Convert an EXIF image orientation to.
+ (UIImageOrientation) exifOrientationToiOSOrientation:(int)exifOrientation {
    UIImageOrientation o = UIImageOrientationUp;
    switch (exifOrientation) {
        case 1: o = UIImageOrientationUp; break;
        case 3: o = UIImageOrientationDown; break;
        case 8: o = UIImageOrientationLeft; break;
        case 6: o = UIImageOrientationRight; break;
        case 2: o = UIImageOrientationUpMirrored; break;
        case 4: o = UIImageOrientationDownMirrored; break;
        case 5: o = UIImageOrientationLeftMirrored; break;
        case 7: o = UIImageOrientationRightMirrored; break; default: break;
    }
    return o;
}

+(int)imageOrientationToExifOrientation:(UIImageOrientation)imageOrientation
{
    int o = 1;
    
    switch (imageOrientation) {             
        case UIImageOrientationUp:          o = 1; break;
        case UIImageOrientationDown:        o = 3; break;
        case UIImageOrientationLeft:        o = 8; break;
        case UIImageOrientationRight:       o = 6; break;
        case UIImageOrientationUpMirrored:  o = 2; break;
        case UIImageOrientationDownMirrored: o = 4; break;
        case UIImageOrientationLeftMirrored: o = 5; break;
        case UIImageOrientationRightMirrored: o = 7; break; default: break;
    }
    return o;
}

#pragma mark - 

+ (BOOL)isAppInBackground {
    return [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
}

#pragma mark - Metric Measure System

+ (BOOL)isMetricMeasureSystem {
    NSLocale *locale = [NSLocale currentLocale];
    BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
    return isMetric;
}


#pragma mark - Pars dicts

NSString *getStringFromKey(id key, NSDictionary *dict)
{
    if ([key length] && [dict objectForKey:key] && [dict objectForKey:key] != [NSNull null] && [[dict objectForKey:key] isKindOfClass:[NSString class]] && [[dict objectForKey:key] length]) {
        return [dict objectForKey:key];
    } else {
        return nil;
    }
}

NSDictionary *getDictionaryFromKey(id key, NSDictionary *dict)
{
    if ([key length] && [dict objectForKey:key] && [dict objectForKey:key] != [NSNull null] && [[dict objectForKey:key] isKindOfClass:[NSDictionary class]] && [[(NSDictionary*)[dict objectForKey:key] allKeys] count] > 0) {
        return [dict objectForKey:key];
    } else {
        return nil;
    }
}

BOOL isObjectIsDictionary(id obj)
{
    if (obj && obj != [NSNull null] && [obj isKindOfClass:[NSDictionary class]] && [[(NSDictionary*)obj allKeys] count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Pars array

NSArray *getArrayFromKey(id key, NSDictionary *dict)
{
    if ([key length] && [dict objectForKey:key] && [dict objectForKey:key] != [NSNull null] && [[dict objectForKey:key] isKindOfClass:[NSArray class]]) {
        return [dict objectForKey:key];
    } else {
        return nil;
    }
}

#pragma mark - Pars number

NSNumber *getNumberFromKey(id key, NSDictionary *dict)
{
    if ([key length] && [dict objectForKey:key] &&
        [dict objectForKey:key] != [NSNull null] &&
        [[dict objectForKey:key] isKindOfClass:[NSNumber class]]) {
        return [dict objectForKey:key];
    } else {
        return [NSNumber numberWithInt:0];
    }
}

@end
