//
//  ViewController.m
// Renault
//
//  Created by Cesar Jacquet on 20/01/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"

@interface ViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrClientInfo;

-(void)loadData;

-(void)eraseAllData;

@end

@implementation ViewController


@synthesize switchErase;
@synthesize buttonErase;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Initialize the dbManager property.
	self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"clientInfoDB.sql"];
	
	// Load the data.
	[self loadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)deleteDataBase:(id)sender {
	
	[self eraseAllData];
	
}

- (IBAction)exportDatabase:(id)sender {
	
	// Export the database to CSV.
	[self.dbManager exportDBtoCSV];
	
	[self displayComposerSheet];
}

-(IBAction) switchPressedAction:(id)sender {
	
	// Lock-unlock the erase button
	if(self.switchErase.on){
		self.buttonErase.enabled = YES;
	}else{
		self.buttonErase.enabled = NO;
	}
}

#pragma mark - Private method implementation


-(void)loadData{
	// Form the query.
	NSString *query = @"select * from clientInfo";
	
	// Get the results.
	if (self.arrClientInfo != nil) {
		self.arrClientInfo = nil;
	}
	self.arrClientInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
	
}

-(void)eraseAllData{
	// Form the query.
	NSString *query = @"delete from clientInfo";
	
	// Execute the query.
	[self.dbManager executeQuery:query];
	
}

-(void)displayComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:@"Export CSV de la base client"];
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"contact@scotta.fr"];
	// NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
	// NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
	
	[picker setToRecipients:toRecipients];
	// [picker setCcRecipients:ccRecipients];
	// [picker setBccRecipients:bccRecipients];
	
	// Set the documents directory path to the documentsDirectory property.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	
	NSString *csvFile = [documentsDir stringByAppendingPathComponent:@"clientInfo.csv"];
	
	NSData *fileData = [NSData dataWithContentsOfFile:csvFile];
	
	[picker addAttachmentData:fileData mimeType:@"text/csv" fileName:@"clientInfo.csv"];
	
	// Fill out the email body text
	NSString *emailBody = @"Email d'export de l'applicationRenault Club";
	[picker setMessageBody:emailBody isHTML:NO];

	[self presentViewController:picker animated:YES completion:nil];

}

#pragma mark - MFMailComposeViewController delegate methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Result: canceled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Result: saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Result: sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Result: failed");
			break;
		default:
			NSLog(@"Result: not sent");
			break;
	}

	[self dismissViewControllerAnimated:YES completion:nil];
}



@end

