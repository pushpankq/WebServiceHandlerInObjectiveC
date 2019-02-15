
#import <Foundation/Foundation.h>

@protocol apiDelegate <NSObject>

@optional

-(void)syncSuccess:(id) responseObject;
-(void)syncFailure:(NSError*) error;

@end

@interface SyncManager : NSObject

-(instancetype)init;
-(void)setNSUserDefault :(NSString*)value key:(NSString*)key;
-(void)removeNSUserDefault:(NSString*)key;

@property (nonatomic, weak) id <apiDelegate> delegate;

-(void) postServiceCall:(NSString*)url withParams:(NSDictionary*) params;
-(void) getServiceCall:(NSString*)url withParams:(NSDictionary*) params;
-(void)putServiceCall:(NSString *)url withParams:(NSDictionary *)params;
+ (id)cleanJsonToObject:(id)data;

@end
