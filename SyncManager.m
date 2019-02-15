
#import "SyncManager.h"

@implementation SyncManager

-(instancetype)init{
    self=[super init];
    if (!self) return nil;
    return self;
}

#pragma mark POST api Calling
-(void) postServiceCall:(NSString*)url withParams:(NSDictionary*) params {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *json= [[self class]cleanJsonToObject:responseObject];
        [self.delegate syncSuccess:json];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [self.delegate syncFailure:error];
    }];
    
}

#pragma mark GET api Calling
-(void) getServiceCall:(NSString*)url withParams:(NSDictionary*) params {
    
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [manager GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
     NSDictionary *json = [[self class]cleanJsonToObject:responseObject];
     [self.delegate syncSuccess:json];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [self.delegate syncFailure:error];
    }];
}

#pragma mark PUT api calling
-(void)putServiceCall:(NSString *)url withParams:(NSDictionary *)params{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager PUT:url parameters:nil success:^(NSURLSessionDataTask * task, id responseObject) {
        NSDictionary *json = [[self class]cleanJsonToObject:responseObject];
        [self.delegate syncSuccess:json];
    } failure:^(NSURLSessionDataTask * operation, NSError * error) {
        [self.delegate syncFailure:error];
    }];
}

#pragma mark NSUserDefault
-(void)setNSUserDefault :(NSString*)value key:(NSString*)key{
    [[NSUserDefaults standardUserDefaults]setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)removeNSUserDefault:(NSString *)key{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark CLEANJSONOBJECT
+ (id)cleanJsonToObject:(id)data {
    NSError* error;
    if (data == (id)[NSNull null]){
        return [[NSObject alloc] init];
    }
    id jsonObject;
    if ([data isKindOfClass:[NSData class]]){
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    } else {
        jsonObject = data;
    }
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [jsonObject mutableCopy];
        for (int i = (int)array.count-1; i >= 0; i--) {
            id a = array[i];
            if (a == (id)[NSNull null]){
                [array removeObjectAtIndex:i];
            } else {
                array[i] = [self cleanJsonToObject:a];
            }
        }
        return array;
    } else if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dictionary = [jsonObject mutableCopy];
        for(NSString *key in [dictionary allKeys]) {
            id d = dictionary[key];
            if (d == (id)[NSNull null]){
                dictionary[key] = @"";
            } else {
                dictionary[key] = [self cleanJsonToObject:d];
            }
        }
        return dictionary;
    } else {
        return jsonObject;
    }
}

@end
