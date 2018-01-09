//
//  TianDiTuLayerInfo.m
//  MapViewDemo-ObjC
//
//  Created by maklMac on 1/6/17.
//  Copyright © 2017 Esri. All rights reserved.
//

#import "TianDiTuLayerInfo.h"
#import <ArcGIS/ArcGIS.h>

#define kURLGetTile @"http://t0.tianditu.com/%@/wmts?service=wmts&request=gettile&version=1.0.0&layer=%@&format=tiles&tilematrixset=%@"

#define tiandituURL @"http://t0.tianditu.com/%@/wmts"

#define X_MIN_MERCATOR -20037508.3427892
#define Y_MIN_MERCATOR -20037508.3427892
#define X_MAX_MERCATOR 20037508.3427892
#define Y_MAX_MERCATOR 20037508.3427892

#define X_MIN_2000 -180.0
#define Y_MIN_2000 -90.0
#define X_MAX_2000 180.0
#define Y_MAX_2000 90.0

#define _minZoomLevel 0
#define _maxZoomLevel 16
#define _tileWidth 256
#define _tileHeight 256
#define _dpi 96

#define _WebMercator 102100
#define _GCS2000 2000

#define kTILE_MATRIX_SET_MERCATOR @"w"
#define kTILE_MATRIX_SET_2000 @"c"



@implementation TianDiTuLayerInfo

@synthesize fullExtent;

-(instancetype)initwithlayerType:(TianDiTuLayerType)layerType SpatialReferenceWKID:(TianDiTuSpatialReferenceType)sptype{
    
    self.layername = @"";
    
    switch (layerType) {
        case 0:
            self.layername = @"vec";
            break;
        case 1:
            self.layername = @"img";
            break;
        case 2:
            self.layername = @"ter";
            break;
        default:
            break;
    }
    
    [self setSpatialReference:sptype];
    self.tileInfo = [self getTianDiTuLayerInfo];

    return self;
    
}

-(instancetype)initwithlayerType:(TianDiTuLayerType)layerType LanguageType:(TianDiTuLanguageType)lan SpatialReferenceWKID:(TianDiTuSpatialReferenceType)sptype{
    self.layername = @"";
    
    
    switch (layerType) {
        case 0:
            switch (lan) {
                case 0:
                    self.layername = @"cva";
                    break;
                case 1:
                    self.layername = @"eva";
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (lan) {
                case 0:
                    self.layername = @"cia";
                    break;
                case 1:
                    self.layername = @"eia";
                    break;
                default:
                    break;
            }
            break;
        case 2:
            self.layername = @"cta";
            break;
        default:
            break;
    }
    
    [self setSpatialReference:sptype];
    self.tileInfo = [self getTianDiTuLayerInfo];
    return self;

}

-(void)setSpatialReference: (TianDiTuSpatialReferenceType)sptype{

    self.sp = [AGSSpatialReference spatialReferenceWithWKID:102100];
    
    self.lods = [[NSMutableArray alloc] init];
    
    double _baseScale = 2.958293554545656E8;
    
    double _baseRelu = 78271.51696402048;
    
    switch (sptype) {
        
        case 0:
            self.sp = [AGSSpatialReference spatialReferenceWithWKID:_WebMercator];
            self.servicename = [[self.layername stringByAppendingString:@"_"] stringByAppendingString:kTILE_MATRIX_SET_MERCATOR];
            
            self.tilematrixset = kTILE_MATRIX_SET_MERCATOR;
            self.origin = [AGSPoint pointWithX:X_MIN_MERCATOR y:Y_MAX_MERCATOR spatialReference:self.sp];
            
            self.fullExtent = [AGSEnvelope envelopeWithXMin:X_MIN_MERCATOR yMin:Y_MIN_MERCATOR xMax:X_MAX_MERCATOR yMax:Y_MAX_MERCATOR spatialReference:self.sp];
            _baseRelu = 78271.51696402048;

            break;
        case 1:
            self.sp = [AGSSpatialReference spatialReferenceWithWKID:_GCS2000];
            self.servicename = [[self.layername stringByAppendingString:@"_"] stringByAppendingString:kTILE_MATRIX_SET_2000];
            self.tilematrixset = kTILE_MATRIX_SET_2000;
            self.origin = [AGSPoint pointWithX:X_MIN_2000 y:Y_MAX_2000 spatialReference:self.sp];
            
            self.fullExtent = [AGSEnvelope envelopeWithXMin:X_MIN_2000 yMin:Y_MIN_2000 xMax:X_MAX_2000 yMax:Y_MAX_2000 spatialReference:self.sp];
            
            _baseRelu = 0.7031249999891485;

            break;
        default:
            break;
            
    }
    
    //build lods for loop from 0 to 17 level
    for(int i= 0; i<=17 ;i++){
        AGSLevelOfDetail *level = [AGSLevelOfDetail levelOfDetailWithLevel:i resolution:_baseRelu scale:_baseScale];
        [self.lods addObject:level];
        
        _baseRelu = _baseRelu / 2;
        _baseScale = _baseScale /2;
        
    }
}


-(AGSTileInfo*)getTianDiTuLayerInfo{
    
    
    AGSTileInfo *tileInfo = [AGSTileInfo tileInfoWithDPI:_dpi format:AGSTileImageFormatPNG32 levelsOfDetail:self.lods origin:self.origin spatialReference:self.sp tileHeight:_tileHeight tileWidth:_tileWidth];
    
    return tileInfo;

}

-(NSString *)getTianDiTuServiceURL{
    
    NSString *wmtsURL = [NSString stringWithFormat:kURLGetTile, self.servicename,self.layername,self.tilematrixset];
    
    return wmtsURL;
}


@end
