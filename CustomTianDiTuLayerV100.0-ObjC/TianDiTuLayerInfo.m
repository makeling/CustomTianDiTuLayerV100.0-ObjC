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

    switch (sptype) {
        
        case 0:
            self.sp = [AGSSpatialReference spatialReferenceWithWKID:_WebMercator];
            self.servicename = [[self.layername stringByAppendingString:@"_"] stringByAppendingString:kTILE_MATRIX_SET_MERCATOR];
            
            self.tilematrixset = kTILE_MATRIX_SET_MERCATOR;
            self.origin = [AGSPoint pointWithX:X_MIN_MERCATOR y:Y_MAX_MERCATOR spatialReference:self.sp];
            
            self.fullExtent = [AGSEnvelope envelopeWithXMin:X_MIN_MERCATOR yMin:Y_MIN_MERCATOR xMax:X_MAX_MERCATOR yMax:Y_MAX_MERCATOR spatialReference:self.sp];
            self.lods = [NSMutableArray arrayWithObjects:
                    [[AGSLevelOfDetail alloc] initWithLevel:1 resolution:78271.51696402048 scale: 2.958293554545656E8],
                    [[AGSLevelOfDetail alloc] initWithLevel:2 resolution:39135.75848201024 scale: 1.479146777272828E8],
                    [[AGSLevelOfDetail alloc] initWithLevel:3 resolution:19567.87924100512 scale: 7.39573388636414E7],
                    [[AGSLevelOfDetail alloc] initWithLevel:4 resolution:9783.93962050256 scale: 3.69786694318207E7],
                    [[AGSLevelOfDetail alloc] initWithLevel:5 resolution:4891.96981025128 scale: 1.848933471591035E7],
                    [[AGSLevelOfDetail alloc] initWithLevel:6 resolution:2445.98490512564 scale: 9244667.357955175],
                    [[AGSLevelOfDetail alloc] initWithLevel:7 resolution:1222.99245256282 scale: 4622333.678977588],
                    [[AGSLevelOfDetail alloc] initWithLevel:8 resolution:611.49622628141 scale: 2311166.839488794],
                    [[AGSLevelOfDetail alloc] initWithLevel:9 resolution:305.748113140705 scale: 1155583.419744397],
                    [[AGSLevelOfDetail alloc] initWithLevel:10 resolution:152.8740565703525 scale: 577791.7098721985],
                    [[AGSLevelOfDetail alloc] initWithLevel:11 resolution:76.43702828517625 scale: 288895.85493609926],
                    [[AGSLevelOfDetail alloc] initWithLevel:12 resolution:38.21851414258813 scale: 144447.92746804963],
                    [[AGSLevelOfDetail alloc] initWithLevel:13 resolution:19.109257071294063 scale: 72223.96373402482],
                    [[AGSLevelOfDetail alloc] initWithLevel:14 resolution:9.554628535647032 scale: 36111.98186701241],
                    [[AGSLevelOfDetail alloc] initWithLevel:15 resolution:4.777314267823516 scale: 18055.990933506204],
                    [[AGSLevelOfDetail alloc] initWithLevel:16 resolution:2.388657133911758 scale:9027.995466753102],
                    [[AGSLevelOfDetail alloc] initWithLevel:17 resolution:1.194328566955879 scale: 4513.997733376551],
                    [[AGSLevelOfDetail alloc] initWithLevel:18 resolution:0.5971642834779395 scale: 2256.998866688275],
                    nil ];

            break;
        case 1:
            self.sp = [AGSSpatialReference spatialReferenceWithWKID:_GCS2000];
            self.servicename = [[self.layername stringByAppendingString:@"_"] stringByAppendingString:kTILE_MATRIX_SET_2000];
            self.tilematrixset = kTILE_MATRIX_SET_2000;
            self.origin = [AGSPoint pointWithX:X_MIN_2000 y:Y_MAX_2000 spatialReference:self.sp];
            
            self.fullExtent = [AGSEnvelope envelopeWithXMin:X_MIN_2000 yMin:Y_MIN_2000 xMax:X_MAX_2000 yMax:Y_MAX_2000 spatialReference:self.sp];
            self.lods = [NSMutableArray arrayWithObjects:
                         [[AGSLevelOfDetail alloc] initWithLevel:1 resolution: 0.7031249999891485 scale: 2.958293554545656E8],
                         [[AGSLevelOfDetail alloc] initWithLevel:2 resolution:0.35156249999999994 scale: 1.479146777272828E8],
                         [[AGSLevelOfDetail alloc] initWithLevel:3 resolution:0.17578124999999997 scale: 7.39573388636414E7],
                         [[AGSLevelOfDetail alloc] initWithLevel:4 resolution:0.08789062500000014 scale: 3.69786694318207E7],
                         [[AGSLevelOfDetail alloc] initWithLevel:5 resolution:0.04394531250000007 scale: 1.848933471591035E7],
                         [[AGSLevelOfDetail alloc] initWithLevel:6 resolution:0.021972656250000007 scale: 9244667.357955175],
                         [[AGSLevelOfDetail alloc] initWithLevel:7 resolution:0.01098632812500002 scale: 4622333.678977588],
                         [[AGSLevelOfDetail alloc] initWithLevel:8 resolution:0.00549316406250001 scale: 2311166.839488794],
                         [[AGSLevelOfDetail alloc] initWithLevel:9 resolution:0.0027465820312500017 scale: 1155583.419744397],
                         [[AGSLevelOfDetail alloc] initWithLevel:10 resolution:0.0013732910156250009 scale: 577791.7098721985],
                         [[AGSLevelOfDetail alloc] initWithLevel:11 resolution:0.000686645507812499 scale: 288895.85493609926],
                         [[AGSLevelOfDetail alloc] initWithLevel:12 resolution:0.0003433227539062495 scale: 144447.92746804963],
                         [[AGSLevelOfDetail alloc] initWithLevel:13 resolution:0.00017166137695312503 scale: 72223.96373402482],
                         [[AGSLevelOfDetail alloc] initWithLevel:14 resolution:0.00008583068847656251 scale: 36111.98186701241],
                         [[AGSLevelOfDetail alloc] initWithLevel:15 resolution:0.000042915344238281406 scale: 18055.990933506204],
                         [[AGSLevelOfDetail alloc] initWithLevel:16 resolution:0.000021457672119140645 scale:9027.995466753102],
                         [[AGSLevelOfDetail alloc] initWithLevel:17 resolution:0.000010728836059570307 scale: 4513.997733376551],
                         [[AGSLevelOfDetail alloc] initWithLevel:18 resolution:0.000005364418029785169 scale: 2256.998866688275],
                         nil ];

            break;
        default:
            break;
            
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
