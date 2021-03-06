/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "PybWifiParameters.h"

@implementation PybWifiParameters

-(void)getCurrentWifiSsid:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground: ^{
        CDVPluginResult * pluginResult = nil;
        CFArrayRef supportInterfaces = CNCopySupportedInterfaces();
        CFDictionaryRef captiveNetworkDict = nil;
        if(supportInterfaces != nil)
        {
            captiveNetworkDict= CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(supportInterfaces, 0));
        }
        NSString *ssid = @"";
        if(captiveNetworkDict != nil)
        {
            NSDictionary *dict = (__bridge NSDictionary *)captiveNetworkDict;
            ssid = [dict objectForKey:@"SSID"];
            if(ssid == NULL)
            {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            }
            else
            {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:ssid];
            }
        }
        else
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
    }];
}

@end