//
//  OEXCourse.h
//  edXVideoLocker
//
//  Created by Rahul Varma on 05/06/14.
//  Copyright (c) 2014 edX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OEXLatestUpdates;
@class OEXCoursewareAccess;

NS_ASSUME_NONNULL_BEGIN

@interface OEXCourse : NSObject

- (id)initWithDictionary:(NSDictionary*)info;

typedef enum {
    OEXStartTypeString,
    OEXStartTypeTimestamp,
    OEXStartTypeNone
} OEXStartType;

// TODO: Rename these to CamelCase
@property (readonly, nonatomic, strong, nullable) OEXLatestUpdates* latest_updates;
@property (readonly, nonatomic, strong, nullable) NSDate* start;
@property (readonly, nonatomic, strong, nullable) NSDate* end;
@property (readonly, nonatomic, copy) NSString* start_display;
@property (readonly, nonatomic) OEXStartType start_type;
@property (readonly, nonatomic, copy, nullable) NSString* course_image_url;
@property (readonly, nonatomic, copy, nullable) NSString* name;
@property (readonly, nonatomic, copy, nullable) NSString* org;
@property (readonly, nonatomic, copy, nullable) NSString* video_outline;
@property (readonly, nonatomic, copy, nullable) NSString* course_id;
@property (readonly, nonatomic, copy, nullable) NSString* subscription_id;
@property (readonly, nonatomic, copy, nullable) NSString* number;
@property (readonly, nonatomic, copy, nullable) NSString* course_updates;         //  ANNOUNCEMENTS
@property (readonly, nonatomic, copy, nullable) NSString* course_handouts;        //  HANDOUTS
@property (readonly, nonatomic, copy, nullable) NSString* course_about;           // COURSE INFO
@property (readonly, nonatomic, strong, nullable) OEXCoursewareAccess* courseware_access;


@property (readonly, nonatomic, assign) BOOL isStartDateOld;
@property (readonly, nonatomic, assign) BOOL isEndDateOld;


@end


NS_ASSUME_NONNULL_END

