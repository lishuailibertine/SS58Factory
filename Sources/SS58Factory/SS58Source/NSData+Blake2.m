//
//  NSData+Blake2.m
//  SS58Factory
//
//  Created by li shuai on 2021/8/27.
//

#import "NSData+Blake2.h"
#import "blake2b.h"

@implementation NSData (Blake2)
- (NSData*)Blake2b{
    NSMutableData *d = [NSMutableData dataWithLength:BLAKE2B_DIGEST_LENGTH];
    blake2b(self.bytes, self.length, d.mutableBytes, d.length);
    return d;
}
- (NSData*)Blake2b:(int)length{
    NSMutableData *d = [NSMutableData dataWithLength:length];
    blake2b(self.bytes, self.length, d.mutableBytes, d.length);
    return d;
}
@end
