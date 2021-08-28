//
//  NSData+Blake2.m
//  SS58Factory
//
//  Created by li shuai on 2021/8/27.
//

#import "NSData+Blake2.h"
@import  CBlake2

#define BLAKE2B_DIGEST_LENGTH  64

@implementation NSData (Blake2)
- (NSData *)Blake2b{
    NSMutableData *d = [NSMutableData dataWithLength:BLAKE2B_DIGEST_LENGTH];
    blake2b(d.mutableBytes, d.length, self.bytes, self.length, nil, 0);
    return (NSData *)d;
}
- (NSData *)Blake2b:(int)length{
    NSMutableData *d = [NSMutableData dataWithLength:length];
    blake2b(d.mutableBytes, d.length, self.bytes, self.length, nil, 0);
    return (NSData *)d;
}
@end
