//
//  HTTPWork.m
//  Basics
//
//  Created by sri-7348 on 28/08/18.
//  Copyright © 2018 sri-7348. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPWork.h"
BOOL shouldKeepRunning=YES;

@implementation HTTPWork

-(void) uploadData{
    NSString *str=@"/agentLogUploader?computerName=%s&domainName=%s&customerId=%s&resourceid=%s&filename=%s";
    NSURL *uploadURL=[NSURL URLWithString:str];
    NSMutableURLRequest *uRequest=[NSMutableURLRequest requestWithURL:uploadURL];
    [uRequest setHTTPMethod:@"POST"];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSString *fileStr=@"/Users/sri-7348/Documents/img1.jpg";
    NSURL *fileURL=[NSURL URLWithString:fileStr];
    NSURLSessionUploadTask *upload=[session uploadTaskWithRequest:uRequest fromFile:fileURL];
    [upload resume];
    //[[NSRunLoop currentRunLoop]run];
    CFRunLoopRef rl=CFRunLoopGetCurrent();
    CFRunLoopRun();
    //CFRunLoopStop(rl);
}

// needs runloop/async dispatch, make it exit runloop
// dont use root user!- wont work cos file path changes
-(void) downloadData{
    NSString *str=@"https://upload.wikimedia.org/wikipedia/en/6/62/MacOS_Mojave_Desktop.jpg";
    NSURL *imageURL=[NSURL URLWithString:str];
    NSMutableURLRequest *dRequest=[NSMutableURLRequest requestWithURL:imageURL];
    [dRequest setHTTPMethod:@"GET"];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDownloadTask *download=[session downloadTaskWithRequest:dRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
            if(error){
                NSLog(@"Error in download \n");
                return;
            }
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSURL *documentsURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
            NSURL *fileURL = [documentsURL URLByAppendingPathComponent:@"Img1.jpg"];
            NSError *moveError;
            if (![fileManager moveItemAtURL:location toURL:fileURL error:&moveError]) {
                NSLog(@"moveItemAtURL failed: %@", moveError);
                return;
            }
            NSLog(@"Response is %@: \n",response);
        
    }];
    
    [download resume]; //triggers the download task
    [[NSRunLoop currentRunLoop]run];
    NSLog(@"object is: %@ \n",download.progress);
    }

-(void)saveFilesInLocalDirectory //working but dont use this synchronous methods for network based URL cos takes a lot of time
{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = @"gandhi.pdf";
    NSString *fileURL = @"http://www.mkgandhi.org/ebks/mindofmahatmagandhi.pdf";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writablePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    if(![fileManager fileExistsAtPath:writablePath]){
        // file doesn't exist
        NSLog(@"file doesn't exist");
        //save Image From URL
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString: fileURL]];
        
        NSError *error = nil;
        [data writeToFile:[documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]] options:NSAtomicWrite error:&error];
        
        if (error) {
            NSLog(@"Error Writing File : %@",error);
        }else{
            NSLog(@"Image %@ Saved SuccessFully",fileName);
        }
    }
    else{
        // file exist
        NSLog(@"file exist");
    }
}

// this method uses DataTask: use runloop/dispatch_async to make this work!
// this doesnt exit run loop, TO.DO: make it exit once download over.
// doesnt work for root user due to file paths
-(void) saveFilesFast{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *str=@"http://upload.wikimedia.org/wikipedia/en/6/62/MacOS_Mojave_Desktop.jpg";
    NSURL *fileURL=[NSURL URLWithString:str];
    NSString *fileName = @"image2.jpg";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writablePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *task1=[session dataTaskWithURL:fileURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        if(error){ //handle error
            NSLog(@"Error occured ! \n");
            NSLog(@"URL response is %@ \n",response);
            return;
        }
        [data writeToFile:[documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]] options:NSAtomicWrite error:&error];
         if(![fileManager fileExistsAtPath:writablePath]){
             NSLog(@"file doesn't exist");
             if (error) {
                 NSLog(@"Error Writing File : %@",error);
             }
             
                NSLog(@"Image %@ Saved SuccessFully",fileName);
                 shouldKeepRunning=NO;
            
         }
         else{
             NSLog(@"File exist.\n");
             shouldKeepRunning=NO;
         }
    }];
    [task1 resume];
    while(shouldKeepRunning){
    [[NSRunLoop currentRunLoop]run];
    }
    
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    NSLog(@"Session is : %@ \n task is %@ \n sent : %lld \n to send: %lld ",session,task,totalBytesSent,totalBytesExpectedToSend);
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    if(error !=NULL){
        NSLog(@"Error occured!: %@ \n",error);
    }
    
}
@end

