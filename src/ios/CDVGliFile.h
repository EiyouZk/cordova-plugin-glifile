#ifndef GliFile_h
#define GliFile_h

#import <Cordova/CDV.h>



@interface CDVGliFile : CDVPlugin


-(void)writefile:(CDVInvokedUrlCommand*) command;

-(void)getfolder:(CDVInvokedUrlCommand*) command;

-(void)readfile:(CDVInvokedUrlCommand*) command;

-(void)downloadfile:(CDVInvokedUrlCommand*)command;

-(void)deletefile:(CDVInvokedUrlCommand*)command;

-(void)existfile:(CDVInvokedUrlCommand*)command;

-(void)getversionName:(CDVInvokedUrlCommand*)command;

-(void)getversioncode:(CDVInvokedUrlCommand*)command;

@end

#endif /* GetPictures_h */
