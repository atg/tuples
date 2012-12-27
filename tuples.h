#import <Foundation/Foundation.h>

id tupleSentinel();

@interface Tuple : NSObject<NSCopying, NSFastEnumeration>

// Creation
- (id)init; // Empty tuple
- (id)initWithArray:(NSArray*)arr;
- (id)initWithObjects:(id)objects, ...;

// Getting an object at an index
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (id)objectAtIndex:(int)idx;

- (id)first;
- (id)second;
- (id)third;

// Unpacking
- (void)unpack:(id*)pointypointers, ...;

// Algorithms
- (Tuple*)map:(id (^)(id x))mapping;

@end

#ifndef tuple
#define tuple(...) [[Tuple alloc] initWithObjects:__VA_ARGS__, tupleSentinel()]
#else
#warning Can't load fileability/tuples.m, because tuple is already defined
#endif

#ifndef unpack
#define unpack(tup, ...) [tup unpack:__VA_ARGS__, NULL]
#endif

#if 0
// Usage:
Tuple* tup = tuple(nil, @10, @"abc")
t[0] --> nil
[t second] --> @10
t[2] --> @"abc"
t[3] --> nil // By design, it is impossible to know the length of a tuple, since you should already know... Any access outside the bounds of the tuple turns into a nil

id a, b; unpack(tup, &a, &b);     --> a = nil, b = @10
#endif

