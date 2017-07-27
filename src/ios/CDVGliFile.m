#import <Foundation/Foundation.h>
#import "CDVGliFile.h"
#import <Cordova/CDV.h>

@interface CDVGliFile()

@end

@implementation CDVGliFile:CDVPlugin


-(void)writefile:(CDVInvokedUrlCommand*)command
{
    NSThread  *thread=[[NSThread alloc]initWithTarget:self
                                             selector:@selector(writefiles:)
                                               object:command];
    [thread start];
    return;
}


-(void)getfoder:(CDVInvokedUrlCommand *)command
{
    NSThread  *thread=[[NSThread alloc]initWithTarget:self
                                             selector:@selector(getfolders:)
                                               object:command];
    [thread start];
    return;
}

-(void)readfile:(CDVInvokedUrlCommand*)command
{
    NSThread  *thread=[[NSThread alloc]initWithTarget:self
                                             selector:@selector(readfiles:)
                                               object:command];
    [thread start];
    return;
}
-(void)deletefile:(CDVInvokedUrlCommand*)command
{
    NSThread  *thread=[[NSThread alloc]initWithTarget:self
                                             selector:@selector(deletefiles:)
                                               object:command];
    [thread start];
    return;
}
-(void)downloadfile:(CDVInvokedUrlCommand*)command
{
    NSThread  *thread=[[NSThread alloc]initWithTarget:self
                                             selector:@selector(downloadfiles:)
                                               object:command];
    [thread start];
    return;
}

-(void)download_file:(CDVInvokedUrlCommand*)command
{
    NSThread  *thread=[[NSThread alloc]initWithTarget:self
                                             selector:@selector(download_files:)
                                               object:command];
    [thread start];
    return;
}

-(void)existfile:(CDVInvokedUrlCommand*)command
{
    NSString *stringURL= [command.arguments objectAtIndex:0];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:stringURL];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:targetPath];
    CDVPluginResult* pluginResult = nil;
    if (!blHave) {
        NSLog(@"no have  %@ ",targetPath);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:false];
    }
    else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

-(void)getversionName:(CDVInvokedUrlCommand*)command
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"%@",app_Version);
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:app_Version];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
-(void)getversioncode:(CDVInvokedUrlCommand*)command
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"%@",app_build);
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:app_build];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

-(void)deletefiles:(CDVInvokedUrlCommand*)command
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSString *stringURL= [command.arguments objectAtIndex:0];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:stringURL];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:targetPath];
    CDVPluginResult* pluginResult = nil;
    if (!blHave) {
        NSLog(@"no have  %@ ",targetPath);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    }
    else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:targetPath error:nil];
        if (blDele) {
            NSLog(@"dele success %@ ",targetPath);
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
        }else {
            NSLog(@"dele fail");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:false];
        }
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
}
-(void)downloadfiles:(CDVInvokedUrlCommand*)command
{
    NSString *stringURL= [command.arguments objectAtIndex:0];
    NSString *path = [command.arguments objectAtIndex:1];
    
    NSString *filename=[[path lastPathComponent] stringByStandardizingPath];
    NSString *dirpath=[path stringByDeletingLastPathComponent];
    
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *targetPath;
        
        if ([dirpath containsString:@"Containers"]) {
            targetPath  = dirpath;
        }else{
            targetPath = [documentsDirectory stringByAppendingPathComponent:dirpath];
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:targetPath]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
            [fileManager createDirectoryAtPath:targetPath  withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", targetPath,filename];
        BOOL res=[urlData writeToFile:filePath atomically:YES];
        CDVPluginResult* pluginResult = nil;
        if (res) {
            NSLog(@"文件下载成功: ");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
        }
        else{
            NSLog(@"文件下载失败: ");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:false];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }
}

-(void)download_files:(CDVInvokedUrlCommand*)command
{
    NSString *stringURL= [command.arguments objectAtIndex:0];
    NSString *path = [command.arguments objectAtIndex:1];
    
    NSString *filename=[[path lastPathComponent] stringByStandardizingPath];
    NSString *dirpath=[path stringByDeletingLastPathComponent];
    
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:dirpath];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:targetPath]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
            [fileManager createDirectoryAtPath:targetPath  withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", targetPath,filename];
        BOOL res=[urlData writeToFile:filePath atomically:YES];
        CDVPluginResult* pluginResult = nil;
        if (res) {
            NSLog(@"文件下载成功: ");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
        }
        else{
            NSLog(@"文件下载失败: ");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:false];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }
}

-(void)readfile1:(CDVInvokedUrlCommand*)command
{
    NSString *path       = [command.arguments objectAtIndex:0];
    NSString *content=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"文件读取成功: %@",content);
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:content];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)writefiles:(CDVInvokedUrlCommand*)command
{
    NSString *path       = [command.arguments objectAtIndex:0];
    NSString *data       = [command.arguments objectAtIndex:1];
//    NSString *dirpath=[path stringByDeletingLastPathComponent];
//    NSString *filename=[[path lastPathComponent] stringByStandardizingPath];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *targetPath = [documentsPath stringByAppendingPathComponent:path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dir=[targetPath stringByDeletingLastPathComponent];
    if(![fileManager fileExistsAtPath:dir]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        [fileManager createDirectoryAtPath:dir  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    BOOL res=[data writeToFile:targetPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    CDVPluginResult* pluginResult = nil;
    if (res) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
        NSLog(@"文件写入成功");
    }else
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:false];
        NSLog(@"文件写入失败");
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)getfolders:(CDVInvokedUrlCommand *)command
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSString *stringURL= [command.arguments objectAtIndex:0];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingPathComponent:stringURL];
    CDVPluginResult* pluginResult = nil;
    BOOL isDir = NO;
    BOOL isExist = [fileManager fileExistsAtPath:targetPath isDirectory:&isDir];
    if(isExist){
        if(isDir){
            NSArray * dirArray = [fileManager contentsOfDirectoryAtPath:targetPath error:nil];
            NSString * subPath = nil;
            NSString * folderstr = nil;
            NSString * returnstr = nil;
            for (NSString * str in dirArray) {
                subPath  = [targetPath stringByAppendingPathComponent:str];
                BOOL issubDir = NO;
                [fileManager fileExistsAtPath:subPath isDirectory:&issubDir];
                if(issubDir){
                    if(folderstr == nil){
                        folderstr =str;
                    }else{
                        folderstr = [folderstr stringByAppendingPathComponent:str];
                    }
                    folderstr = [folderstr stringByAppendingPathComponent:@";"];
                }
            }
            
            returnstr = [folderstr stringByReplacingOccurrencesOfString:@"\/" withString:@""];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:returnstr];
        
        }else{
            NSLog(@"%@",targetPath);
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:nil];
        }
    }else{
        NSLog(@"%@",targetPath);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:nil];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
}

-(void)readfiles:(CDVInvokedUrlCommand*)command
{
    NSString *path       = [command.arguments objectAtIndex:0];
//    NSString *dirpath=[path stringByDeletingLastPathComponent];
//    NSString *filename=[[path lastPathComponent] stringByStandardizingPath];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
 //   NSString *targetDirectory = [documentsPath stringByAppendingPathComponent:dirpath];
    NSString *targetPath = [documentsPath stringByAppendingPathComponent:path];
    NSString *content=[NSString stringWithContentsOfFile:targetPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"文件读取成功: %@",content);
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:content];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
