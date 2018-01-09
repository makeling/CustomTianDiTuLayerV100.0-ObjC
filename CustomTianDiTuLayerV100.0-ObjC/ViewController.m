//
//  ViewController.m
//  CustomTianDiTuLayerV100.0-ObjC
//
//  Created by maklMac on 1/9/17.
//  Copyright © 2017 esrichina.com. All rights reserved.
//

#import "ViewController.h"
#import <ArcGIS/ArcGIS.h>
#import "TianDiTuLayerInfo.h"
#import "TianDiTuLayer.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet AGSMapView *mapView;

@property (nonatomic, strong) AGSMap *map;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //create an instance of a map
    
    self.map = [[AGSMap alloc] init];
    
    TianDiTuLayerInfo *tdtInfo = [[TianDiTuLayerInfo alloc] initwithlayerType:TDT_IMAGE SpatialReferenceWKID:TDT_MERCATOR];
    
    TianDiTuLayerInfo *tdtannoInfo = [[TianDiTuLayerInfo alloc] initwithlayerType:TDT_IMAGE LanguageType:TDT_CN SpatialReferenceWKID:TDT_MERCATOR];
    
    TianDiTuLayer *ltl1 = [[TianDiTuLayer alloc] initWithTianDiTuLayerInfo:tdtInfo];
    
    TianDiTuLayer *ltl2 = [[TianDiTuLayer alloc] initWithTianDiTuLayerInfo:tdtannoInfo];
    
    [[self.map operationalLayers] addObject: ltl1];
    [[self.map operationalLayers] addObject: ltl2];
    
    self.mapView.map = self.map;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
