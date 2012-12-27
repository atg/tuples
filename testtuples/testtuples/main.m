//  Created by Alex Gordon on 27/12/2012.
#import <Foundation/Foundation.h>
#import "../../tuples.h"

BOOL eq(id a, id b) {
    if (a == b) return YES;
    if ([a isEqual:b]) return YES;
    return NO;
}

int cunt(id val) {
    if ([val respondsToSelector:@selector(count)]) return (int)[val count];
    if ([val respondsToSelector:@selector(length)]) return (int)[val length];
    return 0;
}

#define ass(x) assert(x)
#define asseq(a, b) assert(eq(a, b))

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Tuple* tup = tuple(nil, @10, @"Hello", @[ @"a", @"b" ], nil);
        
        NSArray* arr = @[ @"a", @"b" ];
        asseq(tup[-1], nil);
        asseq(tup[0], nil);
        asseq(tup[1], @10);
        asseq(tup[2], @"Hello");
        asseq(tup[3], arr);
        asseq(tup[4], nil);
        asseq(tup[5], nil);
        
        Tuple* tup2 = [tup map:^id(id x) {
            return @(cunt(x));
        }];
        
        asseq(tup2[-1], nil);
        asseq(tup2[0], @0);
        asseq(tup2[1], @0);
        asseq(tup2[2], @5);
        asseq(tup2[3], @2);
        asseq(tup2[4], @0);
        asseq(tup2[5], nil);
        
        Tuple* tup3 = [[Tuple alloc] initWithArray:arr];
        asseq(tup3[-1], nil);
        asseq(tup3[0], @"a");
        asseq(tup3[1], @"b");
        asseq(tup3[2], nil);
        
        asseq([tup3 first], @"a");
        asseq([tup3 second], @"b");
        asseq([tup3 third], nil);
        
        id a, b; unpack(tup3, &a, &b);
        asseq(a, @"a");
        asseq(b, @"b");
        
        id comparedto = @"a";
        for (id obj in tup3) {
            asseq(obj, comparedto);
            comparedto = @"b";
        }
        
        NSLog(@"All good");
    }
    return 0;
}

