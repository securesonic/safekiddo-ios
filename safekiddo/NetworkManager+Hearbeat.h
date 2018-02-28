//
//  NetworkManager+Hearbeat.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 01.02.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "NetworkManager.h"
#import "HeartbeatResponse.h"
@interface NetworkManager (Hearbeat)


+(NSURLSessionTask*)heartbeatWithDeviceUUID:(NSString*)uuid successBlock:(void(^)(HeartbeatResponse*))successBlock failureBlock:(void(^)(NSError*))failureBlock;
@end
