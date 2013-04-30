#import "MiniMathParser.h"
#import <ParseKit/ParseKit.h>

#define LT(i) [self LT:(i)]
#define LA(i) [self LA:(i)]
#define LS(i) [self LS:(i)]
#define LF(i) [self LF:(i)]

#define POP()       [self.assembly pop]
#define POP_STR()   [self _popString]
#define POP_TOK()   [self _popToken]
#define POP_BOOL()  [self _popBool]
#define POP_INT()   [self _popInteger]
#define POP_FLOAT() [self _popDouble]

#define PUSH(obj)     [self.assembly push:(id)(obj)]
#define PUSH_BOOL(yn) [self _pushBool:(BOOL)(yn)]
#define PUSH_INT(i)   [self _pushInteger:(NSInteger)(i)]
#define PUSH_FLOAT(f) [self _pushDouble:(double)(f)]

#define EQ(a, b) [(a) isEqual:(b)]
#define NE(a, b) (![(a) isEqual:(b)])
#define EQ_IGNORE_CASE(a, b) (NSOrderedSame == [(a) compare:(b)])

#define ABOVE(fence) [self.assembly objectsAbove:(fence)]

#define LOG(obj) do { NSLog(@"%@", (obj)); } while (0);
#define PRINT(str) do { printf("%s\n", (str)); } while (0);

@interface PKSParser ()
@property (nonatomic, retain) NSMutableDictionary *_tokenKindTab;
@property (nonatomic, retain) NSMutableArray *_tokenKindNameTab;

- (BOOL)_popBool;
- (NSInteger)_popInteger;
- (double)_popDouble;
- (PKToken *)_popToken;
- (NSString *)_popString;

- (void)_pushBool:(BOOL)yn;
- (void)_pushInteger:(NSInteger)i;
- (void)_pushDouble:(double)d;
@end

@interface MiniMathParser ()
@end

@implementation MiniMathParser

- (id)init {
    self = [super init];
    if (self) {
        self._tokenKindTab[@"*"] = @(MINIMATHPARSER_TOKEN_KIND_STAR);
        self._tokenKindTab[@"("] = @(MINIMATHPARSER_TOKEN_KIND_OPEN_PAREN);
        self._tokenKindTab[@"+"] = @(MINIMATHPARSER_TOKEN_KIND_PLUS);
        self._tokenKindTab[@")"] = @(MINIMATHPARSER_TOKEN_KIND_CLOSE_PAREN);

        self._tokenKindNameTab[MINIMATHPARSER_TOKEN_KIND_STAR] = @"*";
        self._tokenKindNameTab[MINIMATHPARSER_TOKEN_KIND_OPEN_PAREN] = @"(";
        self._tokenKindNameTab[MINIMATHPARSER_TOKEN_KIND_PLUS] = @"+";
        self._tokenKindNameTab[MINIMATHPARSER_TOKEN_KIND_CLOSE_PAREN] = @")";

    }
    return self;
}


- (void)_start {
    
    [self expr]; 
    [self matchEOF:YES]; 

}

- (void)expr {
    
    [self addExpr]; 

}

- (void)addExpr {
    
    [self multExpr]; 
    while ([self predicts:MINIMATHPARSER_TOKEN_KIND_PLUS, 0]) {
        if ([self speculate:^{ [self match:MINIMATHPARSER_TOKEN_KIND_PLUS discard:YES]; [self multExpr]; [self execute:(id)^{PUSH_FLOAT(POP_FLOAT() + POP_FLOAT ());}];}]) {
            [self match:MINIMATHPARSER_TOKEN_KIND_PLUS discard:YES]; 
            [self multExpr]; 
            [self execute:(id)^{
            
    PUSH_FLOAT(POP_FLOAT() + POP_FLOAT ());

            }];
        } else {
            break;
        }
    }

}

- (void)multExpr {
    
    [self primary]; 
    while ([self predicts:MINIMATHPARSER_TOKEN_KIND_STAR, 0]) {
        if ([self speculate:^{ [self match:MINIMATHPARSER_TOKEN_KIND_STAR discard:YES]; [self primary]; [self execute:(id)^{ PUSH_FLOAT(POP_FLOAT() * POP_FLOAT());}];}]) {
            [self match:MINIMATHPARSER_TOKEN_KIND_STAR discard:YES]; 
            [self primary]; 
            [self execute:(id)^{
             
    PUSH_FLOAT(POP_FLOAT() * POP_FLOAT());

            }];
        } else {
            break;
        }
    }

}

- (void)primary {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self atom]; 
    } else if ([self predicts:MINIMATHPARSER_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self match:MINIMATHPARSER_TOKEN_KIND_OPEN_PAREN discard:YES]; 
        [self expr]; 
        [self match:MINIMATHPARSER_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primary'."];
    }

}

- (void)atom {
    
    [self matchNumber:NO];
    [self execute:(id)^{
     
    PUSH_FLOAT(POP_FLOAT()); 

    }];

}

@end