//
//  F4Actuator.m
//  storybubbles
//
//  Created by Romi Phadte on 5/4/15.
//  Copyright (c) 2015 ioet. All rights reserved.
//

#import "F4Actuator.h"

@interface F4Actuator ()
@end

@implementation F4Actuator

-(instancetype)initWithDict:(NSDictionary*) dict{
    if(!self) {
        self=[super init];
    }
    
    _type=dict[@"actuator_type"];
    _UUID=dict[@"UUID"];
    _state=dict[@"state"];
    
    return self;
}

@end
