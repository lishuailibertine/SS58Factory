//
//  MyClass.m
//  
//
//  Created by li shuai on 2021/8/27.
//

#import "Blake2bFool.h"
#import "NSData+Blake2.h"

@implementation Blake2bFool

+ (NSData*)Blake2b:(NSData *)data{
    return [data Blake2b];
}
+ (NSData*)Blake2b:(int)length data:(NSData *)data{
    return [data Blake2b:length];
}
@end
