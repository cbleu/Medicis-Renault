//
//  ViewController.h
// Renault
//
//  Created by Cesar Jacquet on 20/01/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface ViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *switchErase;

@property (weak, nonatomic) IBOutlet UIButton *buttonErase;


- (IBAction)deleteDataBase:(id)sender;

- (IBAction)exportDatabase:(id)sender;

- (IBAction)switchPressedAction:(id)sender;

@end

