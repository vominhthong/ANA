//
//  ChatClientViewController.m
//  ChatClient
//
//  Created by cesarerocchi on 5/27/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import "ChatClientViewController.h"
#import "DDXML.h"
#import "NSXMLElement+XMPP.h"
#import "GCDAsyncSocket.h"
@interface ChatClientViewController () <GCDAsyncSocketDelegate>{
    GCDAsyncSocket *_socket;
    BOOL isCompleted;
}
@end
@implementation ChatClientViewController

@synthesize joinView, chatView;
@synthesize inputStream, outputStream;
@synthesize inputNameField, inputMessageField;
@synthesize tView, messages;


-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    
}
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    [sock readDataWithTimeout:10 tag:100];

    
    NSString *getBindingCode = [[self sendMessageToGetBindingCode] compactXMLString];
    NSMutableData *data = [[[NSData alloc] initWithData:[getBindingCode dataUsingEncoding:NSUTF8StringEncoding]]mutableCopy ];
    NSMutableData *newData = [NSMutableData data];

    const char *charKM = [@"KM" UTF8String];
    [newData appendBytes:charKM length:2];
    
    NSUInteger i = newData.length - 2;
    NSData *lenghtData = [NSData dataWithBytes:&i length:1];
    [newData appendData:lenghtData];
    
    NSData *byteDefault = [NSData dataWithBytes:(unsigned char[]){0x00,0x00,0x00} length:3];
    [newData appendData:byteDefault];
    
    NSData *doubleSpace = [NSData dataWithBytes:(const char*)[@"  " UTF8String] length:2];
    [newData appendData:doubleSpace];
    
    
//    const char *charKM = [@"KM" UTF8String];
//    
//    [newData appendBytes:charKM length:2];
//    int i = data.length;
//    NSData *data1 = [NSData dataWithBytes:&i length:1];
//    [newData appendData:data1];
//    
//    
//    
//    NSData *data2 = [NSData dataWithBytes:(unsigned char[]){0x00,0x00,0x00} length:3];
//    [newData appendData:data2];
//    
////    NSData *data3 = [NSData dataWithBytes:(unsigned char[]){0x00} length:1];
////    [newData appendData:data3];
////    
////    NSData *data4 = [NSData dataWithBytes:(unsigned char[]){0x00} length:1];
////    [newData appendData:data4];
//    
//    const char *constChar5 = [@"  " UTF8String];
//    
//    NSData *data5 = [NSData dataWithBytes:constChar5 length:2];
//    [newData appendData:data5];
////    
////    const char *constChar6 = [@" " UTF8String];
////
////    NSData *data6 = [NSData dataWithBytes:constChar6 length:1];
////    [newData appendData:data6];
//
////
////    const char *charDoubleSpace = [@"  " UTF8String];
////    [newData appendBytes:charDoubleSpace length:2];
    
    [newData appendData:data];
    NSMutableData *dataFinal = [[[NSData alloc]initWithData:newData] mutableCopy];
    [_socket writeData:dataFinal withTimeout:1 tag:101];
}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"Data : %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}
-(void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    
}
-(void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust completionHandler:(void (^)(BOOL))completionHandler{
    
}

-(void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    
}
-(NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length{
    return 10;
}
-(NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length{
    return  10;
}
-(void)socketDidCloseReadStream:(GCDAsyncSocket *)sock{
    
}
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
}
-(void)socketDidSecure:(GCDAsyncSocket *)sock{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
		
    _socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    [_socket connectToHost:@"192.168.1.49" onPort:9392 error:&error];
//
//	[self initNetworkCommunication];
	
	inputNameField.text = @"cesare";
	messages = [[NSMutableArray alloc] init];
	
	self.tView.delegate = self;
	self.tView.dataSource = self;
    
}

- (void) initNetworkCommunication {
	
	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.1.14", 9392, &readStream, &writeStream);

//    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.1.14", 9166, &readStream, &writeStream);

	inputStream = (NSInputStream *)readStream;
	outputStream = (NSOutputStream *)writeStream;
    
	[inputStream setDelegate:self];
	[outputStream setDelegate:self];
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[inputStream open];
	[outputStream open];
	
    [self joinChat];
}

- (IBAction) joinChat {

    NSString *playStr = [[self sendMessageToGetBindingCode] compactXMLString];
    NSData *data = [[NSData alloc] initWithData:[playStr dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}


- (IBAction) sendMessage {
    NSString *playStr = [[self sendMessagePlay] compactXMLString];
	NSData *data = [[NSData alloc] initWithData:[playStr dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
	
}
-(NSXMLElement*)sendMessageToGetBindingCode{
    NSXMLElement *messageTag = [NSXMLElement elementWithName:@"message"];
    NSXMLElement *headTag = [NSXMLElement elementWithName:@"head"];
    [headTag addAttributeWithName:@"fromip" stringValue:@"192.168.0.1"];
    [headTag addAttributeWithName:@"packtype" stringValue:@"32"];
    [headTag addAttributeWithName:@"toip" stringValue:@"192.168.1.14"];
    [headTag addAttributeWithName:@"sessionid" stringValue:@"9472"];
    [headTag addAttributeWithName:@"version" stringValue:@"1"];
    
    NSXMLElement *bodyTag = [NSXMLElement elementWithName:@"body"];
    [bodyTag addAttributeWithName:@"cmdid" stringValue:@"E420"];
    
    [messageTag addChild:headTag];
    [messageTag addChild:bodyTag];
    return messageTag;
    
}

-(NSXMLElement*)sendMessagePlay{
    NSXMLElement *messageTag = [NSXMLElement elementWithName:@"message"];
    NSXMLElement *headTag = [NSXMLElement elementWithName:@"head"];
    [headTag addAttributeWithName:@"fromip" stringValue:@"192.168.0.1"];
    [headTag addAttributeWithName:@"packtype" stringValue:@"32"];
    [headTag addAttributeWithName:@"toip" stringValue:@"192.168.1.36"];
    [headTag addAttributeWithName:@"sessionid" stringValue:@"2387"];
    [headTag addAttributeWithName:@"version" stringValue:@"1"];
    
    NSXMLElement *bodyTag = [NSXMLElement elementWithName:@"body"];
    [bodyTag addAttributeWithName:@"cmdid" stringValue:@"E400"];
    [bodyTag addAttributeWithName:@"roombindingcode" stringValue:@"3300000319216800103648"];
    [bodyTag addAttributeWithName:@"controltype" stringValue:@"10"];
    [bodyTag addAttributeWithName:@"controlvalue" stringValue:@"1"];

    [messageTag addChild:bodyTag];
    [messageTag addChild:headTag];
    return messageTag;

}
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
		
	NSLog(@"stream event %i", streamEvent);
    NSLog(@"stream error code : %@",theStream.streamError.localizedDescription);
	switch (streamEvent) {
			
		case NSStreamEventOpenCompleted:
            if (!isCompleted) {
                isCompleted = YES;
                NSString *getBindingCode = [[self sendMessageToGetBindingCode] compactXMLString];
                NSMutableData *data = [[[NSData alloc] initWithData:[getBindingCode dataUsingEncoding:NSUTF8StringEncoding]]mutableCopy ];
                
                NSMutableData *newData = [NSMutableData data];
                
                const char *charKM = [@"KM" UTF8String];
                
                [newData appendBytes:charKM length:2];
                
                const char *constData1 = [[NSString stringWithFormat:@"0x%lX",
                                           (unsigned long)[getBindingCode length]] UTF8String];
                
                NSData *data1 = [NSData dataWithBytes:constData1 length:1];
                [newData appendData:data1];
                
                NSData *data2 = [NSData dataWithBytes:(unsigned char[]){0x00} length:1];
                [newData appendData:data2];
                
                NSData *data3 = [NSData dataWithBytes:(unsigned char[]){0x00} length:1];
                [newData appendData:data3];
                
                NSData *data4 = [NSData dataWithBytes:(unsigned char[]){0x00} length:1];
                [newData appendData:data4];
                
                const char *constChar5 = [@" " UTF8String];
                
                NSData *data5 = [NSData dataWithBytes:constChar5 length:1];
                [newData appendData:data5];
                
                NSData *data6 = [NSData dataWithBytes:(unsigned char[]){0x20} length:1];
                [newData appendData:data6];
                
                //
                //    const char *charDoubleSpace = [@"  " UTF8String];
                //    [newData appendBytes:charDoubleSpace length:2];
                
                [newData appendData:data];
                NSMutableData *dataFinal = [[[NSData alloc]initWithData:newData] mutableCopy];
                [outputStream write:[newData bytes] maxLength:newData.length];

            }
			NSLog(@"NSStreamEventOpenCompleted");
			break;
		case NSStreamEventHasBytesAvailable:
            NSLog(@"NSStreamEventHasBytesAvailable");
			if (theStream == inputStream) {
				
				uint8_t buffer[1024];
				int len;
				
				while ([inputStream hasBytesAvailable]) {
					len = [inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0) {
						
						NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
						
						if (nil != output) {

							NSLog(@"server said: %@", output);
							[self messageReceived:output];
							
						}
					}
				}
			}
			break;

			
		case NSStreamEventErrorOccurred:
			
			NSLog(@"NSStreamEventErrorOccurred");
			break;
			
		case NSStreamEventEndEncountered:
            NSLog(@"NSStreamEventEndEncountered");
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [theStream release];
            theStream = nil;
			
			break;
        case NSStreamEventHasSpaceAvailable:{
        }
            break;
        case NSStreamEventNone:{
            NSLog(@"NSStreamEventNone");
        }
            break;
		default:
			NSLog(@"Unknown event");
	}
		
}

- (void) messageReceived:(NSString *)message {
	
	[self.messages addObject:message];
	[self.tView reloadData];
	NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1 
												   inSection:0];
	[self.tView scrollToRowAtIndexPath:topIndexPath 
					  atScrollPosition:UITableViewScrollPositionMiddle 
							  animated:YES];

}

#pragma mark -
#pragma mark Table delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *s = (NSString *) [messages objectAtIndex:indexPath.row];
	
    static NSString *CellIdentifier = @"ChatCellIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.textLabel.text = s;
	
	return cell;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return messages.count;
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {

	[joinView release];
	[chatView release];
	[inputStream release];
	[outputStream release];
	[inputNameField release];
	[inputMessageField release];
	[tView release];
    [super dealloc];
	
}


@end
