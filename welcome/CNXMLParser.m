//
//  CNXMLParser.m
//  IDCWelcome
//
//  Created by Mac on 13-11-28.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "CNXMLParser.h"
#import "ParamMapping.h"
#import "TBXML.h"
#import "ServiceUri.h"

@implementation CNXMLParser
-(NSMutableArray *)parserParamMapping:(NSString *)filePath{
    //    <mapping>
    //    <tag>MAPPING-USERNAME</tag>
    //    <value></value>
    //	</mapping>
    //	<mapping>
    //    <tag>MAPPING-PASSWORD</tag>
    //    <value></value>
    //	</mapping>
    NSMutableArray *paramArray = [[NSMutableArray alloc]init];
    TBXML *tbxml = [[TBXML alloc]initWithXMLFile:filePath];
    TBXMLElement *root = tbxml.rootXMLElement;
    if(root){
        TBXMLElement *mapping = [TBXML childElementNamed:@"mapping" parentElement:root];
        if(mapping){
            while (mapping) {
                ParamMapping *param = [[ParamMapping alloc]init];
                TBXMLElement *tag = [TBXML childElementNamed:@"tag" parentElement:mapping];
                if(tag){
                    NSString *tagStr = [TBXML textForElement:tag];
                    param.tag = tagStr;
                }
                TBXMLElement *value = [TBXML childElementNamed:@"value" parentElement:mapping];
                if(value){
                    NSString *valueStr = [TBXML textForElement:value];
                    param.value = valueStr;
                }
                mapping = [TBXML nextSiblingNamed:@"mapping" searchFromElement:mapping];
                [paramArray addObject:param];
                
            }
        }
    }
    return paramArray;
}
-(NSMutableArray *)parserServiceUri:(NSString *)filePath{
    //    <ws name="login">
    //    <webservice>http://1.202.208.29:8899/HuasunMobileInterface/Services/MobileServiceIDC</webservice>
    //    <tagname>http://idc.webservice/</tagname>
    //    <method>MobileLogin</method>
    //    <param>[{'UserName':'MAPPING-USERNAME','Password':'MAPPING-PASSWORD','IMEI':'MAPPING-IMEI','IMSI':'MAPPING-IMSI','Model':'MAPPING-MODEL','Uuid':'MAPPING-UUID','inRoomNum':'MAPPING-INROOMNUM'}]</param>
    //	</ws>
    
    NSMutableArray *serviceArray = [[NSMutableArray alloc]init];
    TBXML *tbxml = [[TBXML alloc]initWithXMLFile:filePath];
    TBXMLElement *root = tbxml.rootXMLElement;
    if(root){
        TBXMLElement *ws = [TBXML childElementNamed:@"ws" parentElement:root];
        if(ws){
            while (ws) {
                ServiceUri *uri = [[ServiceUri alloc]init];
                TBXMLAttribute *attribute = ws->firstAttribute;
                uri.name = [TBXML attributeValue:attribute];
                
                TBXMLElement *webservice = [TBXML childElementNamed:@"webservice" parentElement:ws];
                if(webservice){
                    NSString *webserviceStr = [TBXML textForElement:webservice];
                    uri.webservice = webserviceStr;
                }
                TBXMLElement *tagname = [TBXML childElementNamed:@"tagname" parentElement:ws];
                if(tagname){
                    NSString *tagnameStr = [TBXML textForElement:tagname];
                    uri.tagname = tagnameStr;
                }
                TBXMLElement *method = [TBXML childElementNamed:@"method" parentElement:ws];
                if(method){
                    NSString *methodStr = [TBXML textForElement:method];
                    uri.method = methodStr;
                }
                TBXMLElement *param = [TBXML childElementNamed:@"param" parentElement:ws];
                if(param){
                    NSString *paramStr = [TBXML textForElement:param];
                    uri.paramStr = paramStr;
                }
                [serviceArray addObject:uri];
                ws = [TBXML nextSiblingNamed:@"ws" searchFromElement:ws];
            }
        }
    }
    return serviceArray;
}
@end
