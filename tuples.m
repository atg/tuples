#import "tuples.h"

id tupleSentinel() {
    static id sentin;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sentin = [[NSObject alloc] init];
    });
    return sentin;
}

@interface Tuple ()

- (NSPointerArray*)_storage;
- (void)_setStorage:(NSPointerArray*)newstorage;

@end

@implementation Tuple {
    NSPointerArray* storage;
}
- (NSPointerArray*)_storage {
    return storage;
}
- (void)_setStorage:(NSPointerArray*)newstorage {
    storage = newstorage;
}


// Initialization
- (id)init {
    self = [super init];
    if (!self)
        return nil;
    
    storage = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPersonality];
    
    return self;
}
- (id)initWithArray:(NSArray*)arr {
    self = [self init];
    if (!self)
        return nil;
    
    for (id obj in arr) {
        [storage addPointer:(__bridge void *)obj];
    }
    
    return self;
}
- (id)initWithObjects:(id)objects, ... {
    self = [self init];
    if (!self)
        return nil;
    
    va_list ap;
    va_start(ap, objects);
    
    id obj = objects;
    id sentin = tupleSentinel();
    while (obj != sentin) {
        [storage addPointer:(__bridge void *)obj];
        obj = va_arg(ap, id);
    }
    va_end(ap);
    
    return self;
}

// Protocolic Obligations
- (id)copyWithZone:(NSZone *)zone {
    id newtup = [[[self class] alloc] init];
    [newtup _setStorage:[[self _storage] copy]];
    return newtup;
}
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])stackbuf count:(NSUInteger)len {
    return [storage countByEnumeratingWithState:state objects:stackbuf count:len];
}

// Getting an object at an index
- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self objectAtIndex:(int)idx];
}
- (id)objectAtIndex:(int)idx {
    if (idx < 0 || idx >= (int)[storage count])
        return nil;
    return (__strong id)[storage pointerAtIndex:idx];
}

- (id)first {
    return [self objectAtIndex:0];
}
- (id)second {
    return [self objectAtIndex:1];
}
- (id)third {
    return [self objectAtIndex:2];
}

// Unpacking
- (void)unpack:(id*)pointypointers, ... {
    
    va_list ap;
    va_start(ap, pointypointers); 
    
    __autoreleasing id* pp = pointypointers;
    int i = 0;
    while (pp != NULL) {
        *pp = [self objectAtIndex:i];
        
        pp = va_arg(ap, __autoreleasing id*);
        i++;
    }
    va_end(ap);
    
}

// Algorithms
- (Tuple*)map:(id (^)(id x))mapping {
    
    Tuple* newtup = [self copy];
    NSPointerArray* newstorage = [newtup _storage];
    for (int i = 0, n = (int)[newstorage count]; i != n; i++) {
        id old = (__strong id)[storage pointerAtIndex:i];
        [newstorage replacePointerAtIndex:i withPointer:(__bridge void *)mapping(old)];
    }
    
    return newtup;
}

@end
