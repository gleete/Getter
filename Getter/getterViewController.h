//
//  getterViewController.h
//  Getter
//
//  Created by Gordon Leete on 11/5/13.
//  Copyright (c) 2013 Gordon Leete. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface getterViewController : UIViewController {
    IBOutlet UITextView *textView;
    IBOutlet UIActivityIndicatorView *spinner;
    NSMutableData *responseData;
    NSString *urlString;
}

-(IBAction)buttonClicked:(id)sender;
-(void)loadData;
-(void)parseData;

@end
