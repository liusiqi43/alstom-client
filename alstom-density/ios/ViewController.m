//
//  ViewController.m
//  ios
//
//  Created by Siqi Liu on 12/18/14.
//  Copyright (c) 2014 Alstom. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
#import "StationsNameIdDataSource.h"
#import "GeoStationsIdDataSource.h"
#import "MLPAutoCompleteTextField.h"
#import "TrainsViewController.h"
#import "AutoCompleteCell.h"
#import "DataFetcher.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *background;

// Fields
@property (strong, nonatomic) StationsNameIdDataSource * namesDataSource;
@property (strong, nonatomic) GeoStationsIdsDataSource * geoDataSource;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *textfield_departure;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *textfield_arrival;

// Geo
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.namesDataSource = [[StationsNameIdDataSource alloc] init];
    self.geoDataSource = [[GeoStationsIdsDataSource alloc] init];
    [self.textfield_arrival setAutoCompleteDataSource: self.geoDataSource];
    [self.textfield_departure setAutoCompleteDataSource: self.geoDataSource];
    self.background.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.50];
    
    [self registerForKeyboardNotifications];
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
        [self.textfield_departure setBackgroundColor:[UIColor whiteColor]];
        [self.textfield_departure setBorderStyle:UITextBorderStyleRoundedRect];
        [self.textfield_arrival setBackgroundColor:[UIColor whiteColor]];
        [self.textfield_arrival setBorderStyle:UITextBorderStyleRoundedRect];
    }
    else{
        //Turn off bold effects on iOS 5.0 as they are not supported and will result in an exception
        self.textfield_arrival.applyBoldEffectToAutoCompleteSuggestions = NO;
        self.textfield_departure.applyBoldEffectToAutoCompleteSuggestions = NO;
    }
    
    self.textfield_departure.delegate = self;
    self.textfield_arrival.delegate = self;
    
    [self.textfield_departure addTarget:self action:@selector(stopGeolocalising:) forControlEvents:UIControlEventEditingChanged];
    [self.textfield_departure addTarget:self action:@selector(setNameDataSource:) forControlEvents:UIControlEventEditingChanged];
    
    [self initGeo];
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _background.contentInset = contentInsets;
    _background.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _textfield_departure.frame.origin) ) {
        [_background scrollRectToVisible:_textfield_departure.autoCompleteTableView.frame animated:YES];
    }
    if (!CGRectContainsPoint(aRect, _textfield_arrival.frame.origin) ) {
        [_background scrollRectToVisible:_textfield_arrival.autoCompleteTableView.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _background.contentInset = contentInsets;
    _background.scrollIndicatorInsets = contentInsets;
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)initGeo
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
    self.textfield_departure.placeholder = @"Mise à jour votre localisation...";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)stopGeolocalising:(id)sender
{
    [self.locationManager stopUpdatingLocation];
    self.textfield_departure.placeholder = @"Station de départ";
}

- (void)setNameDataSource:(id)sender
{
    NSLog(@"Set source to NameDataSource if denied");
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self.textfield_departure setAutoCompleteDataSource:self.namesDataSource];
        [self.textfield_arrival setAutoCompleteDataSource:self.namesDataSource];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Update UnSuccessful");
    [self stopGeolocalising:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Update Successful");
    [self stopGeolocalising:nil];
    [self.geoDataSource setCurrentLocation:newLocation];
    [self.textfield_departure setAutoCompleteDataSource:self.geoDataSource];
    
    [self.textfield_departure becomeFirstResponder];
    [self.textfield_departure reloadData];
}

- (void) setColorCodeFor:(UITextField *)field onId: (NSNumber *)id {
    if (!id) {
        // textField empty
        field.layer.borderWidth = 2.0f;
        field.layer.borderColor = [[UIColor redColor] CGColor];
    } else {
        field.layer.borderColor = [[UIColor clearColor] CGColor];
        field.layer.borderWidth = 0.0f;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"getNextTrainsSegue"])
    {
        TrainsViewController *vc = [segue destinationViewController];
        vc.departureStationName = [self.textfield_departure text];
        vc.arrivalStationName = [self.textfield_arrival text];
    }
}

- (IBAction)getNextTrains:(id)sender {
    DataFetcher *fetcher = [DataFetcher sharedInstance];
    NSNumber *departureId = [fetcher getIdForStationName:[self.textfield_departure text]];
    NSNumber *arrivalId = [fetcher getIdForStationName:[self.textfield_arrival text]];
    
    [self setColorCodeFor:self.textfield_departure onId:departureId];
    [self setColorCodeFor:self.textfield_arrival onId:arrivalId];
    
    if (departureId == arrivalId) {
        [self setColorCodeFor:self.textfield_departure onId:nil];
        [self setColorCodeFor:self.textfield_arrival onId:nil];
    }
    
    if (departureId && arrivalId && departureId != arrivalId) {
        // Segue to trains ViewController
        [self performSegueWithIdentifier:@"getNextTrainsSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
