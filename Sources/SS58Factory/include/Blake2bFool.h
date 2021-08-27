//
//  MyClass.h
//  
//
//  Created by li shuai on 2021/8/27.
//

#import <Foundation/Foundation.h>

@protocol SS58AddressFactoryProtocol
+ (NSData*)Blake2b:(NSData *)data;
+ (NSData*)Blake2b:(int)length data:(NSData *)data;
@end

@interface Blake2bFool : NSObject

@end
