//
//  ViewController.m
//  FindMyPi
//
//  Created by Programmer/Analyst on 10/6/16.
//  Copyright © 2016 Justin Snow. All rights reserved.
//

#import "ViewController.h"
#include <sys/xattr.h>
#include "IPAddress.h"
#include "RemoteMac.h"

@implementation ViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)ipButtonClicked:(id)sender {
    NSString *ip_text = _ip_text_box.stringValue;
    const char *ipxx = [ip_text cStringUsingEncoding:NSUTF8StringEncoding];
    ipcc = ipxx;

   [self checkconnection];

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)clicked_button:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];

    //NSString * lab_text = _label.stringValue;
    NSString *host_text = _host_text_box.stringValue;
    
    if (host_text.length != 0)
    {
        [self findmyip:(host_text)];
        [self getmac:(@"127.0.0.1")];
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

- (void)checkconnection
{
    ConnectionMain();
    //const char *ipc = [ip UTF8String];
    //TestConnection(ipc);
    char *statuss1 = "noconnection";
    NSString* xx = [NSString stringWithUTF8String:statuss];
    //printf("%s\n", statuss);
    if(strcmp(statuss, statuss1) == 0)
    {
      _ip_label.stringValue = @"No Connection";
      ipcc = NULL;
      statuss = NULL;
      statuss1 = NULL;
    }
    else
    {
      _ip_label.stringValue = @"Connection Success";
      ipcc = NULL;
      statuss = NULL;
      statuss1 = NULL;

    }
    
    
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

- (void)getmac:(NSString*)ipAddr {
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    int i;
    NSString *deviceIP = nil;
    for (i=0; i<MAXADDRS; ++i)
    {
        static unsigned long localHost = 0xac1100a2;
        unsigned long theAddr;
        
        theAddr = ip_addrs[i];
        
        if (theAddr == 0) break;
        if (theAddr == localHost) continue;
        
        NSLog(@"Name: %s MAC: %s IP: %s\n", if_names[i], hw_addrs[i], ip_names[i]);
        
        //decided what adapter you want details for
        if (strncmp(if_names[i], "en", 2) == 0)
        {
            NSLog(@"Adapter en has a IP of %s", ip_names[i]);
        }
    }
}

- (IBAction)ip_text_box:(id)sender {
}

- (IBAction)iplabel1:(id)sender {
}

- (IBAction)host_text_box:(id)sender {
}

- (IBAction)label1:(id)sender {
    
    
    
}
@end
