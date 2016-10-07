//
//  ViewController.m
//  FindMyPi
//
//  Created by Programmer/Analyst on 10/6/16.
//  Copyright © 2016 Justin Snow. All rights reserved.
//

#import "ViewController.h"
#include <sys/xattr.h>

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)clicked_button:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];

    NSString * lab_text = _label.stringValue;
    NSString *host_text = _host_text_box.stringValue;
    
    if (host_text.length != 0)
    {
        [self findmyip:(host_text)];
        //if (![self isIp:(lab_text)])
        //{
        //    _label.stringValue = @"Nothing Found :'(";
        //}
        
    }
    
    else
    {
        [alert setMessageText:@"Please enter a valid hostname"];
        [alert setInformativeText:@"ex: host.domain.com"];
        [alert addButtonWithTitle:@"Okay"];
        [alert addButtonWithTitle:@"Cancel"];

        [alert runModal];
    }
}

- (BOOL)isIp:(NSString*)string{
    struct in_addr pin;
    int success = inet_aton([string UTF8String],&pin);
    if (success == 1) return TRUE;
    return FALSE;
}


- (void)findmyip:(NSString *)host_name {
    NSString* hostname = host_name;
    CFHostRef hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostname);
    Boolean lookup = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
    
    if (lookup) {
        CFArrayRef addresses = CFHostGetAddressing(hostRef, &lookup);
        
        struct sockaddr_in *remoteAddr;
        
        for(int i = 0; i < CFArrayGetCount(addresses); i++) {
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
            remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
            if(remoteAddr != NULL){
                NSString *strDNS = [NSString stringWithUTF8String:inet_ntoa(remoteAddr->sin_addr)];

                _label.stringValue = strDNS;

            }
        }
        CFRelease(addresses);
        
    }
}



- (IBAction)host_text_box:(id)sender {
}

- (IBAction)label1:(id)sender {
    
    
    
}
@end
