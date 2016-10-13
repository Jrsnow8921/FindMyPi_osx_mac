//
//  RemoteMac.h
//  FindMyPi
//
//  Created by Programmer/Analyst on 10/11/16.
//  Copyright © 2016 Justin Snow. All rights reserved.
//

#ifndef RemoteMac_h
#define RemoteMac_h

#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

extern const char *ipcc;

extern char *statuss;

//const char *TestConnection(const char *ip);

void ConnectionMain();

#endif /* RemoteMac_h */
