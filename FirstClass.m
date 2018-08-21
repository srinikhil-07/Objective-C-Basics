//
//  main.m
//  HelloWorld
//
//  Created by sri-7348 on 16/08/18.
//  Copyright © 2018 sri-7348. All rights reserved.
//

// My very first objective C program
/*Foundation has extended data types,URL,error,data handling capabilities and rich manipulating functions*/
#import <Foundation/Foundation.h>
#define let __auto_type const
#define var __auto_type

@interface FirstClass: NSObject //declared here can only be used in this class
@property int myVar1, myVar2;
- (FirstClass*) setFirstVar: (int) a andSecond: (int) b;
- (void) firstMethod; //suddenly not working!
- (void) DataSize;
- (void) NSArrayFunction;
- (void) NSStringFunction;
-(void) NSDictFunction;
- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs;
-(void) timerRoutine1:(NSTimer *) timer;
-(void) timerBlock;
-(void) launchProcess; //this class can be made as standalone and executed which launches daemon plist which inturn calls
// main.m 's executable. that is iBooks is opened in user uid 502

@end

@implementation FirstClass

@synthesize myVar1, myVar2;
- (FirstClass *) setFirstVar:(int)a andSecond:(int)b{
    myVar1=a;
    myVar2=b;
    [self firstMethod];
    FirstClass *firstObj=[[FirstClass alloc]init];
    firstObj.myVar2=10;
    firstObj.myVar1=9;
    return firstObj;
}
- (void) firstMethod{ //identifier starts with letter, _. Also @,$,% are not allowed
    NSLog(@"Hello WOrld, this language is so weird! \n"); // made up of tokens e.g., there are six here
    NSMethodSignature *sgn=[self methodSignatureForSelector:@selector(timerRoutine1:)]; //setting method signature for invocation
    NSInvocation *inv=[NSInvocation invocationWithMethodSignature:sgn]; // setting an invocation for timer
    [inv setTarget:self];
    [inv setSelector:@selector(timerRoutine1:)];
    NSTimer *fnCaller=[NSTimer timerWithTimeInterval:2.0 invocation:inv repeats:YES];//set interval timer for run loop
    //scheduledTimerWithTimeInterval:2.0 invocation:inv repeats:YES]
    NSRunLoop *run =[NSRunLoop currentRunLoop];
    [run addTimer:fnCaller forMode:NSDefaultRunLoopMode]; //default run loop would get an event every t seconds and the handler part triggers the routine
    //[fnCaller invalidate];
    
}

// TO.DO: pass data type as parameter and print the values
- (void) DataSize{
    // printing sizes of various data types
    NSLog(@"sizes of various data types \n");
    NSLog(@"Int is %lu \n",sizeof(int));
    NSLog(@"%lu \n ",sizeof(unsigned char));
    NSLog(@"%lu \n ",sizeof(short));
    NSLog(@"%lu \n ",sizeof(unsigned short));
    NSLog(@"%lu \n ",sizeof(long));
    NSLog(@"%lu \n ",sizeof(unsigned long));
    NSLog(@"%lu \n ",sizeof(char));
    NSLog(@"%lu \n ",sizeof(unsigned char));
    NSLog(@"%lu \n ",sizeof(signed char));
    NSLog(@"%lu \n ",sizeof(float));
    NSLog(@"%lu \n ",sizeof(double));
    NSLog(@"%lu \n ",sizeof(long double));
    //NSLog(@"%lu /n ",sizeof(char));
    NSLog(@"%lu \n ",sizeof(void));
}
// TO.DO: firstObject, lastObject, objectAtIndex,objectAtIndexedSubscript (raises exception) ,objectAtIndexes(set of indices), objectEnumerator
// See file and URL for NSArray
// init block example and line 89
-(void) NSArrayFunction{
    // NSArrays - static array and NSMutableArrays -dynamic arrays
    // example 1: array with values
    NSArray *array=@[@"Nikhil",@1];
    NSString *val= array[0];
    NSLog(@"Value at first var is %@ \n", val);
    
    
    NSArray *arrEmpty=[NSArray array];  // eg 2: initializing static empty arrays can also use [[NSArray alloc] init]
    NSArray *arrEmpty1=[[NSArray alloc] init ]; // alloc: allocates memory and init: initializes
    NSLog(@"%@ and %@ is the value of empty array : \n",arrEmpty,arrEmpty1);
    
    NSArray *arrWithObj=[NSArray arrayWithObject:@"Nikhil"]; //Eg 3:static array with 1 object
    NSLog(@"%@ array with 1 object: \n",arrWithObj);
    
    NSArray *arrObjs=[NSArray arrayWithObjects:@"Nikhil",@"Apple",nil]; // multiple objects, can use C array as well with count, initWithObjects can also be used
    NSArray *arrObjs1=[[NSArray alloc] initWithObjects:@"Nikhil",@"Duggirala",nil];
    NSLog(@"%@ and %@ are: \n",arrObjs,arrObjs1);
    NSString *strVals[3];
    strVals[0]=@"Nikhil";
    strVals[1]=@"Corporation";
    strVals[2]=@"Estancia";
    NSArray *arrCstr=[[NSArray alloc] initWithObjects:strVals count:2]; //get c strings of count
    NSLog(@"From C strings : %@ \n",arrCstr);
    
    NSArray *arrArr =[NSArray arrayWithArray:arrObjs]; // forming an array from an array, can also use NSArray constructor and initWithArray
    //var arrArr1= [NSArray array:array];
    NSArray *arrArr2= [[NSArray alloc]initWithArray:arrArr]; //initialize an array
    NSLog(@"%@ and %@ \n",arrArr,arrArr2);
    
    //querying
    BOOL containsObj=[array containsObject:@"Nikhil"]; //querying
    NSLog(@"array may/maynot have an object: %d \n",containsObj);
    
    NSLog(@"No.fo objects in arrObj is : %lu",[arrObjs count]); //count,
    
    //id rangeEg; // id is a pointer to object of any type, can be casted to any type
    //NSRange aryRange=NSMakeRange(1, 2);
    // rangeEg=(__bridge id)(malloc(sizeof(id)*aryRange.length));
    
    NSArray *cities = [NSArray arrayWithObjects:@"New Delhi",@"London", @"Brisbane", @"Adelaide", nil];// at index query
    NSLog(@"City at index %d is : %@",1,[cities objectAtIndex:1]);
    
    NSLog(@"Looping examples \n");
    for(NSString *city in cities ){ //eg 1
        NSLog(@"City is : %@ \n",city);
    }
    for(int itr=0;itr<[cities count];itr++){ //eg2;
        NSLog(@"%d city is %@ \n",itr,cities[itr]);
    }
    
    if(![cities isEqualToArray:arrObjs1]){
        NSLog(@"Both arrays not equal! \n");
    }
    
    NSUInteger ind= [cities indexOfObject:@"Nikhil"]; //index querying
    if(ind==NSNotFound){
        NSLog(@"Item not found \n");
    }
    else{
        NSLog(@"Item found! \n");
    }
    
    NSArray *addArray=[cities arrayByAddingObjectsFromArray:arrObjs1]; //add an array
    NSLog(@"array with additional on=bjects is %@ \n",addArray);
    
    NSLog(@"array as strings: %@",[addArray componentsJoinedByString:@", "]); //string thing
    
    //Mutable arrays
    NSMutableArray *sports = [NSMutableArray arrayWithObjects: @"Cricket", @"Football",@"Hockey", @"Table Tennis", nil];
    [sports addObject:@"Badminton"];
    NSLog(@"Sports after add: %@ \n",sports);
    [sports removeLastObject];
    NSLog(@"After deletion: %@ \n",sports);
}

-(void) NSStringFunction{
    // init,
    NSString *sample =@"macOS Dev";
    NSString *pcInfo=[NSString stringWithFormat:@"This is %@ from year %d \n",sample,2018];
    NSLog(@"Printing... %@ \n",pcInfo);
    
    //comparision,
    NSString *str=@"Zoho Corporation";
    if([str isEqualToString:@"Zoho Corporation"]){
        NSLog(@"Strings seem equal");
    }
    if([str hasPrefix:@"Zoho"]){
        NSLog(@"Prefix equal too!\n");
    }
    if([str hasSuffix:@"Corporation"]){
        NSLog(@"Has the suffix! \n");
    }
    NSString *otrStr=@"Estancia IT park";
    NSComparisonResult strComp=[str compare:otrStr];
    if(strComp==NSOrderedAscending){
        NSLog(@"Z comes before E");
    }
    else if(strComp==NSOrderedSame){
        NSLog(@"Z is equal to E \n");
    }
    else if(strComp==NSOrderedDescending){
        NSLog(@"Z comes after E \n");
    }
    
    // appending strings
    NSString *addString=[pcInfo stringByAppendingString:str];
    NSLog(@"Added str is %@ \n",addString);
    
    // searching strings
    NSRange searchStr=[addString rangeOfString:@"Zoho"];
    if(searchStr.location==NSNotFound){
        NSLog(@"No string found! \n");
    }
    else{
        NSLog(@"%lu is the length  snd %lu is the location",searchStr.length,searchStr.location);
    }
    
    //NSMutableStrings
    NSMutableString *muStr= [NSMutableString stringWithString:@"Mutable strings !"];
    [muStr setString:@"Mutated string!"];
    NSLog(@"%@ is the mutated string",muStr);
}

//TO.DO: implement file,URL and filter methods
-(void) NSDictFunction{
    //non mutable dictionary
    NSDictionary *dict=@{@"key1":@"val1",@"key2":@"val2",@"key3":@"val3"};
    NSLog(@"Value of key1 is %@ \n",dict[@"Key1"]);
    
    //dictionary with dictionary
    NSDictionary *appendDict=[NSDictionary dictionaryWithDictionary:dict];
    NSLog(@"appended dictionary is %@ \n",appendDict);
    
    NSLog(@"Is dictioanaries equal? %cs \n",[appendDict isEqualToDictionary:dict]);
    
    //accessing dictionary
    NSArray *keys=[dict allKeys];
    NSArray *allVal=[dict allValues];
    NSLog(@"the keys of dict are %@ and values are %@ \n",keys,allVal);
    
    NSEnumerator *keyEnum=[dict keyEnumerator]; //key enumerator, there s also a data enum
    id myEnum;
    while(myEnum =[keyEnum nextObject]){
        NSLog(@"%@",myEnum);
    }
    
}

// example of running NSRunLoop until some event occurs
- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs {
    BOOL done=true;
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    // runMode:NSDefaultRunLoopMode beforeDate:timeoutDate
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate]; //run loop once blocking for input in specified mode until given date
        if([timeoutDate timeIntervalSinceNow] < 1.0) {// difference between date object and current date and time
            //break;
            NSLog(@"Almost 1 second!");
        }
        else if([timeoutDate timeIntervalSinceNow] < 0.0){
            break;
        }
    } while (!done);
    
    return done;
}

-(void) timerRoutine1:(NSTimer *) timer{
    NSLog(@"Printing output!");
    
}

-(void) timerBlock{
    NSTimer *bTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * timer) {
        NSLog(@"Run block!");
    }];
    NSRunLoop *run =[NSRunLoop currentRunLoop];
    [run addTimer:bTimer forMode:NSDefaultRunLoopMode];
}
// 840063083 --> current user UID, 502 --> otheruser UID
//launchctl bsexec 1218 load /Library/LaunchDaemons/com.myexec.runAtLoad.plist
-(void) launchProcess{
    NSTask *task=[[NSTask alloc] init];
    [task setExecutableURL:[NSURL fileURLWithPath:@"/bin/sh"]];
    [task setArguments:[NSArray arrayWithObjects:@"-c",@"launchctl asuser 502 launchctl load /Library/LaunchDaemons/com.myexec.runAtLoad.plist",nil]]; // use chown to change owner to make this work!!
    
    NSPipe *oPipe=[[NSPipe alloc] init];
    NSPipe *ePipe=[[NSPipe alloc]init];
    [task setStandardOutput:oPipe];
    [task setStandardError:ePipe];
    NSError *error =nil;
    if(![task launchAndReturnError:(&error)]){
        NSLog(@"Error in NSTask! with error :%@ \n",error);
        return;
    }
    [task waitUntilExit]; //block until receiver is finished
    if(task.terminationStatus !=0){
        //ERROR
        NSFileHandle *file=ePipe.fileHandleForReading;
        NSData *data=[file readDataToEndOfFile];
        [file closeFile];
        NSString *errMsg=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"ERROR (%i); %@ ",task.terminationStatus,errMsg);
        return;
    }
    //SUCCESS
    NSFileHandle *file =oPipe.fileHandleForReading;
    NSData *data=[file readDataToEndOfFile];
    [file closeFile];
    NSString *outMsg=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"OUtput is : %@",outMsg);
}

@end

/*

int main(){
    // class instantiation
    FirstClass *firstClassObject=[[FirstClass alloc]init]; //case sensitive
    // set intance variables
    firstClassObject.myVar1=10;
    int temp=firstClassObject.myVar1;
    //FirstClass *initVar2=[firstClassObject setFirstVar:temp andSecond:10];
    // object methods
    
    int choice;
    choice=3;
    NSLog(@"Choice 1: Trigger a routine every t seconds! \n");
    NSLog(@"Choice 2: Examples of NSStings, NSArrays and NSDictionary \n");
    NSLog(@"Choice 3: execute a block of code asynchronously \n");
    NSLog(@"Choice 4: Creates a process which triggers a task every t seconds \n");
    NSLog(@"Enter choice \n");
    if (choice ==1){
        //scanf("%i",&choice);
        //if (choice==1){
        // *dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
         dispatch_async(queue, ^{
         NSLog(@"I am inside async block!");
         [firstClassObject firstMethod];
         });
         */
/*
        //run loop example
        //BOOL res=[firstClassObject waitForCompletion:2 ];
        //NSLog(@"BOOL I got is %cs \n",res);
        
        //}
        //else if(choice==2){
        [firstClassObject DataSize];
        [firstClassObject NSArrayFunction];
        [firstClassObject NSStringFunction];
        //}
        //else if(choice==3){
        // *async implies main thread wont wait for the function to complete the task. Eg.,time consuming acts can be made async to
         enable UI handle user requests without freezing*/
        // asynchronous usage example
/*        dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSLog(@"I am inside async block!");
            
            [firstClassObject firstMethod];
        });
    }
   
    else if(choice==3){
        [firstClassObject launchProcess];
    }
    //}
    // @synchronized block ensures thread safety in multithreaded programs
    
    //NSRunLoops: mechanism to handle system input sources. we add input/time sources of the thread to the loop
    // each application has one by default, when an input comes from reg source, runloop triggers an event
    //else if(choice==4){
    // threads, use it for any lengthy task that you wish to not disturb rest of application
    // also useful to divide large jobs to several smaller jobs
    // *NSThread *egThread;
     egThread=[egThread initWithTarget:firstClassObject selector:@selector(firstMethod) object:NULL];
     [egThread start];
    //}
    
    //[NSTimer scheduledTimerWithTimeInterval:10.0 target:firstClassObject selector:@selector(timerRoutine1:) userInfo:NULL repeats:YES];
    return 0;
}*/
/*Notes:
 Run Loop: Event processing loop, secondary threads need explicit Run loops
 
 */
