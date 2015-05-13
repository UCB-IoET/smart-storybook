//
//  F4Actuator.h
//  storybubbles
//
//  Created by Romi Phadte on 5/4/15.
//  Copyright (c) 2015 ioet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface F4Actuator : NSObject

-(instancetype) initWithDict:(NSDictionary*) dict;


@property (strong, readonly, nonatomic, getter=type) NSString *type;
@property (strong, readonly, nonatomic, getter=UUID) NSString *UUID;
@property (strong, readonly, nonatomic, getter=state) NSString *state;




@end
