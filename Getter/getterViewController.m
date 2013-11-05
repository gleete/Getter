//
//  getterViewController.m
//  Getter
//
//  Created by Gordon Leete on 11/5/13.
//  Copyright (c) 2013 Gordon Leete. All rights reserved.
//

#import "getterViewController.h"

@interface getterViewController ()

@end

@implementation getterViewController

#pragma mark
#pragma mark NSURLConnection delegate methods

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"didRecieveData - data = %@", data);
    //convert to string from binary
    NSString *string = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"didRecieveData - data to string = %@", string);
    [responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    [spinner stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
    [self parseData];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [spinner stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
    NSLog(@"didFailWithError error= %@",error);
}

-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response {
    //cast NSURLresponse to NSHTTPURLResponse
    //get header information
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    //log information about response
    //hey where's the data?
    NSLog(@"didRecieveResponse response = %@",httpResponse);
    NSLog(@"HTTP status code = %d",[httpResponse statusCode]);
    NSLog(@"headers = %@", [httpResponse allHeaderFields]);
    NSString *lastModStr = [[httpResponse allHeaderFields] objectForKey:@"Last-Mod"];
    NSLog(@"Last-mod date = %@", [NSDate dateWithTimeIntervalSince1970:[lastModStr floatValue]]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    urlString = @"http://www.ist.rit.edu/~bdf/454/nationalParks.php?type=plist";
    spinner.hidesWhenStopped = YES;
}

-(IBAction)buttonClicked:(id)sender {
    [self loadData];
}

-(void)loadData {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        responseData = [NSMutableData data];
        //show network activity
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        //show our spinner
        [spinner startAnimating];
    }
    NSLog(@"Connection= %@",connection);
}


-(void) parseData {
    NSLog(@"parseDats! data = %@", responseData);
    NSString *string = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    textView.text = string;
    //save response to plist
    //get path to Documents directory
    NSString *applicationDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //now create our full path to write the plist to
    NSString *fullpath  = [applicationDocumentsDirectory stringByAppendingPathComponent:@"data.plist"];
    //now try to write the file
    //probably should check if it is a valid plist first
    NSError *error;
    if ([string writeToFile:fullpath atomically:YES encoding:NSUTF8StringEncoding error:&error]){
        NSLog(@"data.plist written to disk SUCCESSFULLY");
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:fullpath];
        NSLog(@"here is the dictionary: \n dict = %@",dict);
        
    }
    else {
        NSLog(@"Problem writing data.plist to file! error=%@",error);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
