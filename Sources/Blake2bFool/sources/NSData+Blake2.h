//
//  NSData+Blake2.h
//  SS58Factory
//
//  Created by li shuai on 2021/8/27.
//

#import <Foundation/Foundation.h>
@interface NSData (Blake2)
- (NSData *)Blake2b;
- (NSData *)Blake2b:(int)length;
@end
