//
//  CreateReferenceViewController.h
//  ResearchProjectTrackerApp
//
//  Created by Lucas Damian Napoli on 02/10/14.
//  Copyright (c) 2014 microsoft. All rights reserved.
//

#import "ViewController.h"
#import "office365-lists-sdk/ListItem.h"

@interface CreateReferenceViewController : ViewController
@property (weak, nonatomic) IBOutlet UITextField *referenceTitle;
@property (weak, nonatomic) IBOutlet UITextField *referenceUrlTxt;
@property (weak, nonatomic) IBOutlet UITextField *referenceDescription;
@property NSString* token;
@property ListItem* project;
@end
