#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import "Entity.h"

@interface Equipment : NSObject <Entity>

@property (nonatomic, strong) NSString *mId;
@property (nonatomic, strong) NSString *mName;
@property (nonatomic, strong) NSMutableArray *mAlarms;
@property (nonatomic, strong) NSString *mType;
@property (nonatomic, strong) NSString *mVisual;
@property (nonatomic, strong) NSValue *mShape;

- (Equipment *) initWithType:(NSString *)type
                        Name:(NSString *)name
                          Id:(NSString *)ID
                       Shape:(NSValue *)shape
                      Visual:(NSString *)visual
                      Alarms:(NSMutableArray *)alarms;
- (NSString *) getMaxLevel;

@end
