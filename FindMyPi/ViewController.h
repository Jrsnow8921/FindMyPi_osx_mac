//
//  ViewController.h
//  FindMyPi
//
//  Created by Programmer/Analyst on 10/6/16.
//  Copyright © 2016 Justin Snow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <stdio.h>
#include <stdlib.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include  <arpa/inet.h>
@interface ViewController : NSViewController


- (IBAction)label1:(id)sender;
@property (weak) IBOutlet NSButton *ButtonClick;
@property (weak) IBOutlet NSTextField *label;
@property (weak) IBOutlet NSTextField *host_text_box;

@end

