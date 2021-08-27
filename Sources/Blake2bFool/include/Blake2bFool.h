//
//  MyClass.h
//  
//
//  Created by li shuai on 2021/8/27.
//

#import <Foundation/Foundation.h>

@protocol Blake2bFoolProtocol
+ (NSData*)Blake2b:(NSData *)data;
+ (NSData*)Blake2b:(int)length data:(NSData *)data;
@end

@interface Blake2bFool : NSObject<Blake2bFoolProtocol>

@end
