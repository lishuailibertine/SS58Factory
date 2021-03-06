//
//  NSMutableData+Bitcoin.m
//  bitheri
//
//  Copyright 2014 http://Bither.net
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  Copyright (c) 2013-2014 Aaron Voisine <voisine@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "NSMutableData+Extend.h"

@implementation NSMutableData (Extend)

static void *secureAllocate(CFIndex allocSize, CFOptionFlags hint, void *info) {
    void *ptr = CFAllocatorAllocate(kCFAllocatorDefault, sizeof(CFIndex) + allocSize, hint);
    
    if (ptr) { // we need to keep track of the size of the allocation so it can be cleansed before deallocation
        *(CFIndex *) ptr = allocSize;
        return (CFIndex *) ptr + 1;
    }
    else return NULL;
}

static void *secureReallocate(void *ptr, CFIndex newsize, CFOptionFlags hint, void *info) {
    // There's no way to tell ahead of time if the original memory will be deallocted even if the new size is smaller
    // than the old size, so just cleanse and deallocate every time.
    void *newptr = secureAllocate(newsize, hint, info);
    CFIndex size = *((CFIndex *) ptr - 1);
    
    if (newptr) {
        if (size) {
            memcpy(newptr, ptr, size < newsize ? size : newsize);
            secureDeallocate(ptr, info);
        }
        
        return newptr;
    }
    else return NULL;
}

static void secureDeallocate(void *ptr, void *info) {
    CFIndex size = *((CFIndex *) ptr - 1);
    
    if (size) {
        memset(ptr, 0, size);
        CFAllocatorDeallocate(kCFAllocatorDefault, (CFIndex *) ptr - 1);
    }
}

// Since iOS does not page memory to storage, all we need to do is cleanse allocated memory prior to deallocation.
CFAllocatorRef SecureAllocator() {
    static CFAllocatorRef alloc = NULL;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        CFAllocatorContext context;
        
        context.version = 0;
        CFAllocatorGetContext(kCFAllocatorDefault, &context);
        context.allocate = secureAllocate;
        context.reallocate = secureReallocate;
        context.deallocate = secureDeallocate;
        
        alloc = CFAllocatorCreate(kCFAllocatorDefault, &context);
    });
    
    return alloc;
}

+ (NSMutableData *)secureData {
    return [self secureDataWithCapacity:0];
}

+ (NSMutableData *)secureDataWithCapacity:(NSUInteger)aNumItems {
    return CFBridgingRelease(CFDataCreateMutable(SecureAllocator(), aNumItems));
}

+ (NSMutableData *)secureDataWithLength:(NSUInteger)length {
    NSMutableData *d = [self secureDataWithCapacity:length];
    
    d.length = length;
    return d;
}

+ (NSMutableData *)secureDataWithData:(NSData *)data {
    return CFBridgingRelease(CFDataCreateMutableCopy(SecureAllocator(), 0, (__bridge CFDataRef) data));
}

- (void)appendUInt8:(uint8_t)i {
    [self appendBytes:&i length:sizeof(i)];
}

- (void)appendUInt16:(uint16_t)i {
    i = CFSwapInt16HostToLittle(i);
    [self appendBytes:&i length:sizeof(i)];
}

- (void)appendUInt32:(uint32_t)i {
    i = CFSwapInt32HostToLittle(i);
    [self appendBytes:&i length:sizeof(i)];
}

- (void)appendUInt64:(uint64_t)i {
    i = CFSwapInt64HostToLittle(i);
    [self appendBytes:&i length:sizeof(i)];
}

- (void)appendVarInt:(uint64_t)i {
    
    do {
        Byte b = (Byte)((i) & 0x7f);
        i >>= 7;
        b |= ( ((i > 0) ? 1 : 0 ) << 7 );
        [self appendBytes:&b length:1];
    } while( i != 0 );
}
- (void)appendVarData:(NSData *)data{
    NSUInteger l = data.length;
    [self appendVarInt:l];
    [self appendBytes:data.bytes length:l];
}

- (void)appendVarDatas:(NSArray<NSData *> *)datas{
    [self appendVarInt:datas.count];
    for (NSData *d in datas) {
        [self appendVarData:d];
    }
}

- (void)appendString:(NSString *)s {
    NSUInteger l = [s lengthOfBytesUsingEncoding:NSUTF8StringEncoding];

    [self appendVarInt:l];
    [self appendBytes:s.UTF8String length:l];
}

#pragma mark - ONT
- (void)ont_appendVarInt:(uint64_t)i{
    if (i < 0xFD) {
        [self appendUInt8:i];
    } else if (i <= 0xFFFF) {
        [self appendUInt8:0xFD];
        [self appendUInt16:(uint16_t)i];
    } else if (i <= 0xFFFFFFFF) {
        [self appendUInt8:0xFE];
        [self appendUInt32:(uint32_t)i];
    } else {
        [self appendUInt8:0xFF];
        [self appendUInt64:i];
    }
}
- (void)ont_appendVarData:(NSData *)data{
    NSUInteger l = data.length;
    [self ont_appendVarInt:l];
    [self appendBytes:data.bytes length:l];
}

- (void)ont_appendString:(NSString *)s{
    NSUInteger l = [s lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    [self ont_appendVarInt:l];
    [self appendBytes:s.UTF8String length:l];
}
@end
