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

- (void)startTimedTask
{
    NSTimer *fiveSecondTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(performBackgroundTask) userInfo:nil repeats:NO];
}

- (void)performBackgroundTask
{
    NSString *ip_text = _ip_text_box.stringValue;
    const char *ipxx = [ip_text cStringUsingEncoding:NSUTF8StringEncoding];
    ipcc = ipxx;
    if ([self isValidIpAddress:(ip_text)])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self checkconnection];
                
            });
        });
    }
    else
    {
        _ip_label.stringValue = @"Invalid IP Address";
    }

}

- (IBAction)ipButtonClicked:(id)sender {


    self.load_progress.minValue = 0.0;
    self.load_progress.maxValue = 5.0;
    [self.load_progress setIndeterminate:NO];
    
    self.load_progress.doubleValue = 0.001; // if you want to see it animate the first iteration, you need to start it at some small, non-zero value
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i = 1; i <= self.load_progress.maxValue; i++)
        {
            [NSThread sleepForTimeInterval:1.0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.load_progress setDoubleValue:(double)i];
                [self.load_progress displayIfNeeded];

                
            });
        }
    });
    [self startTimedTask];
    
    
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)clicked_button:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];

    //NSString * lab_text = _label.stringValue;
    NSString *host_text = _host_text_box.stringValue;
    self.load_progress.minValue = 0.0;
    self.load_progress.maxValue = 5.0;
    [self.load_progress setIndeterminate:NO];
    
    self.load_progress.doubleValue = 0.001; // if you want to see it animate the first iteration, you need to start it at some small, non-zero value
    
    
    if (host_text.length != 0)
    {

        //if (![self isIp:(lab_text)])
        //{
        //    _label.stringValue = @"Nothing Found :'(";
        //}
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (NSInteger i = 1; i <= self.load_progress.maxValue; i++)
            {
                [NSThread sleepForTimeInterval:1.0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.load_progress setDoubleValue:(double)i];
                    [self.load_progress displayIfNeeded];
                    
                    
                });
            }
        });
        
        [self findmyip:(host_text)];
        [self getmac:(@"127.0.0.1")];
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

- (BOOL)isValidIpAddress:(NSString *)ip {
    const char *utf8 = [ip UTF8String];
    
    // Check valid IPv4.
    struct in_addr dst;
    int success = inet_pton(AF_INET, utf8, &(dst.s_addr));
    if (success != 1) {
        // Check valid IPv6.
        struct in6_addr dst6;
        success = inet_pton(AF_INET6, utf8, &dst6);
    }
    return (success == 1);
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
