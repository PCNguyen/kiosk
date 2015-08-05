/**
 * Autogenerated by Thrift Compiler (0.9.2)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */

#import <Foundation/Foundation.h>

#import "TProtocol.h"
#import "TApplicationException.h"
#import "TProtocolException.h"
#import "TProtocolUtil.h"
#import "TProcessor.h"
#import "TObjective-C.h"
#import "TBase.h"


enum TimePeriod {
  TimePeriod_CURRENT_WEEK = 1,
  TimePeriod_LAST_WEEK = 2,
  TimePeriod_CURRENT_MONTH = 3,
  TimePeriod_LAST_MONTH = 4,
  TimePeriod_CURRENT_YEAR = 5,
  TimePeriod_LAST_YEAR = 6
};

@interface Actor : NSObject <TBase, NSCoding> {
  NSString * __id;
  NSString * __role;
  NSString * __name;

  BOOL __id_isset;
  BOOL __role_isset;
  BOOL __name_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=id, setter=setId:) NSString * id;
@property (nonatomic, retain, getter=role, setter=setRole:) NSString * role;
@property (nonatomic, retain, getter=name, setter=setName:) NSString * name;
#endif

- (id) init;
- (id) initWithId: (NSString *) id role: (NSString *) role name: (NSString *) name;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (void) validate;

#if !__has_feature(objc_arc)
- (NSString *) id;
- (void) setId: (NSString *) id;
#endif
- (BOOL) idIsSet;

#if !__has_feature(objc_arc)
- (NSString *) role;
- (void) setRole: (NSString *) role;
#endif
- (BOOL) roleIsSet;

#if !__has_feature(objc_arc)
- (NSString *) name;
- (void) setName: (NSString *) name;
#endif
- (BOOL) nameIsSet;

@end

@interface ActivityObject : NSObject <TBase, NSCoding> {
  NSString * __id;
  NSString * __idFieldName;
  NSString * __parentId;
  NSString * __sentiment;

  BOOL __id_isset;
  BOOL __idFieldName_isset;
  BOOL __parentId_isset;
  BOOL __sentiment_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=id, setter=setId:) NSString * id;
@property (nonatomic, retain, getter=idFieldName, setter=setIdFieldName:) NSString * idFieldName;
@property (nonatomic, retain, getter=parentId, setter=setParentId:) NSString * parentId;
@property (nonatomic, retain, getter=sentiment, setter=setSentiment:) NSString * sentiment;
#endif

- (id) init;
- (id) initWithId: (NSString *) id idFieldName: (NSString *) idFieldName parentId: (NSString *) parentId sentiment: (NSString *) sentiment;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (void) validate;

#if !__has_feature(objc_arc)
- (NSString *) id;
- (void) setId: (NSString *) id;
#endif
- (BOOL) idIsSet;

#if !__has_feature(objc_arc)
- (NSString *) idFieldName;
- (void) setIdFieldName: (NSString *) idFieldName;
#endif
- (BOOL) idFieldNameIsSet;

#if !__has_feature(objc_arc)
- (NSString *) parentId;
- (void) setParentId: (NSString *) parentId;
#endif
- (BOOL) parentIdIsSet;

#if !__has_feature(objc_arc)
- (NSString *) sentiment;
- (void) setSentiment: (NSString *) sentiment;
#endif
- (BOOL) sentimentIsSet;

@end

@interface ActivitySource : NSObject <TBase, NSCoding> {
  NSString * __sourceId;
  NSString * __type;
  NSString * __sourceName;

  BOOL __sourceId_isset;
  BOOL __type_isset;
  BOOL __sourceName_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=sourceId, setter=setSourceId:) NSString * sourceId;
@property (nonatomic, retain, getter=type, setter=setType:) NSString * type;
@property (nonatomic, retain, getter=sourceName, setter=setSourceName:) NSString * sourceName;
#endif

- (id) init;
- (id) initWithSourceId: (NSString *) sourceId type: (NSString *) type sourceName: (NSString *) sourceName;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (void) validate;

#if !__has_feature(objc_arc)
- (NSString *) sourceId;
- (void) setSourceId: (NSString *) sourceId;
#endif
- (BOOL) sourceIdIsSet;

#if !__has_feature(objc_arc)
- (NSString *) type;
- (void) setType: (NSString *) type;
#endif
- (BOOL) typeIsSet;

#if !__has_feature(objc_arc)
- (NSString *) sourceName;
- (void) setSourceName: (NSString *) sourceName;
#endif
- (BOOL) sourceNameIsSet;

@end

@interface Target : NSObject <TBase, NSCoding> {
  NSString * __id;
  NSString * __type;
  NSString * __name;

  BOOL __id_isset;
  BOOL __type_isset;
  BOOL __name_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=id, setter=setId:) NSString * id;
@property (nonatomic, retain, getter=type, setter=setType:) NSString * type;
@property (nonatomic, retain, getter=name, setter=setName:) NSString * name;
#endif

- (id) init;
- (id) initWithId: (NSString *) id type: (NSString *) type name: (NSString *) name;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (void) validate;

#if !__has_feature(objc_arc)
- (NSString *) id;
- (void) setId: (NSString *) id;
#endif
- (BOOL) idIsSet;

#if !__has_feature(objc_arc)
- (NSString *) type;
- (void) setType: (NSString *) type;
#endif
- (BOOL) typeIsSet;

#if !__has_feature(objc_arc)
- (NSString *) name;
- (void) setName: (NSString *) name;
#endif
- (BOOL) nameIsSet;

@end

@interface Activity : NSObject <TBase, NSCoding> {
  int64_t __tenantId;
  NSString * __locationId;
  NSString * __verb;
  NSString * __type;
  int64_t __published;
  Actor * __actor;
  ActivityObject * __object;
  ActivitySource * __source;
  Target * __target;
  NSString * __activityString;

  BOOL __tenantId_isset;
  BOOL __locationId_isset;
  BOOL __verb_isset;
  BOOL __type_isset;
  BOOL __published_isset;
  BOOL __actor_isset;
  BOOL __object_isset;
  BOOL __source_isset;
  BOOL __target_isset;
  BOOL __activityString_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=tenantId, setter=setTenantId:) int64_t tenantId;
@property (nonatomic, retain, getter=locationId, setter=setLocationId:) NSString * locationId;
@property (nonatomic, retain, getter=verb, setter=setVerb:) NSString * verb;
@property (nonatomic, retain, getter=type, setter=setType:) NSString * type;
@property (nonatomic, getter=published, setter=setPublished:) int64_t published;
@property (nonatomic, retain, getter=actor, setter=setActor:) Actor * actor;
@property (nonatomic, retain, getter=object, setter=setObject:) ActivityObject * object;
@property (nonatomic, retain, getter=source, setter=setSource:) ActivitySource * source;
@property (nonatomic, retain, getter=target, setter=setTarget:) Target * target;
@property (nonatomic, retain, getter=activityString, setter=setActivityString:) NSString * activityString;
#endif

- (id) init;
- (id) initWithTenantId: (int64_t) tenantId locationId: (NSString *) locationId verb: (NSString *) verb type: (NSString *) type published: (int64_t) published actor: (Actor *) actor object: (ActivityObject *) object source: (ActivitySource *) source target: (Target *) target activityString: (NSString *) activityString;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (void) validate;

#if !__has_feature(objc_arc)
- (int64_t) tenantId;
- (void) setTenantId: (int64_t) tenantId;
#endif
- (BOOL) tenantIdIsSet;

#if !__has_feature(objc_arc)
- (NSString *) locationId;
- (void) setLocationId: (NSString *) locationId;
#endif
- (BOOL) locationIdIsSet;

#if !__has_feature(objc_arc)
- (NSString *) verb;
- (void) setVerb: (NSString *) verb;
#endif
- (BOOL) verbIsSet;

#if !__has_feature(objc_arc)
- (NSString *) type;
- (void) setType: (NSString *) type;
#endif
- (BOOL) typeIsSet;

#if !__has_feature(objc_arc)
- (int64_t) published;
- (void) setPublished: (int64_t) published;
#endif
- (BOOL) publishedIsSet;

#if !__has_feature(objc_arc)
- (Actor *) actor;
- (void) setActor: (Actor *) actor;
#endif
- (BOOL) actorIsSet;

#if !__has_feature(objc_arc)
- (ActivityObject *) object;
- (void) setObject: (ActivityObject *) object;
#endif
- (BOOL) objectIsSet;

#if !__has_feature(objc_arc)
- (ActivitySource *) source;
- (void) setSource: (ActivitySource *) source;
#endif
- (BOOL) sourceIsSet;

#if !__has_feature(objc_arc)
- (Target *) target;
- (void) setTarget: (Target *) target;
#endif
- (BOOL) targetIsSet;

#if !__has_feature(objc_arc)
- (NSString *) activityString;
- (void) setActivityString: (NSString *) activityString;
#endif
- (BOOL) activityStringIsSet;

@end

@interface ActivityPeriod : NSObject <TBase, NSCoding> {
  int __timePeriod;
  NSMutableArray * __activities;

  BOOL __timePeriod_isset;
  BOOL __activities_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=timePeriod, setter=setTimePeriod:) int timePeriod;
@property (nonatomic, retain, getter=activities, setter=setActivities:) NSMutableArray * activities;
#endif

- (id) init;
- (id) initWithTimePeriod: (int) timePeriod activities: (NSMutableArray *) activities;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (void) validate;

#if !__has_feature(objc_arc)
- (int) timePeriod;
- (void) setTimePeriod: (int) timePeriod;
#endif
- (BOOL) timePeriodIsSet;

#if !__has_feature(objc_arc)
- (NSMutableArray *) activities;
- (void) setActivities: (NSMutableArray *) activities;
#endif
- (BOOL) activitiesIsSet;

@end

@interface MobileActivityConstants : NSObject {
}
@end
