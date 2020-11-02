//
//  OKPyCommandsManager.m
//  OneKey
//
//  Created by bixin on 2020/10/27.
//  Copyright © 2020 Calin Culianu. All rights reserved.
//

#import "OKPyCommandsManager.h"
@interface OKPyCommandsManager()
@property (nonatomic,assign)PyObject *pyClass;
@end

@implementation OKPyCommandsManager
static dispatch_once_t once;
+ (OKPyCommandsManager *)sharedInstance {
    static OKPyCommandsManager *_sharedInstance = nil;
    dispatch_once(&once, ^{
        PyGILState_STATE state = PyGILState_Ensure();
        _sharedInstance = [[OKPyCommandsManager alloc] init];
        PyObject *pModule = PyImport_ImportModule([@"api.android.console" UTF8String]);//导入模块
        if (pModule == NULL) {
               PyErr_Print();
        }
        PyObject *pyClass = PyObject_GetAttrString(pModule, [@"AndroidCommands" UTF8String]);//获取类
        _sharedInstance.pyClass = pyClass;
        PyObject *pyConstract = PyInstanceMethod_New(pyClass);
        PyObject* pIns = PyObject_CallObject(pyConstract,NULL);//创建实例
        if (pIns == NULL) {
            PyErr_Print();
        }
        _sharedInstance.pyInstance = pIns;
        PyGILState_Release(state);
    });
    return _sharedInstance;
}

- (id)callInterface:(NSString *)method parameter:(NSDictionary *)parameter
{

    if (parameter == nil) {
        parameter = [NSDictionary dictionary];
    }
    PyGILState_STATE state = PyGILState_Ensure();
    PyObject *result = NULL;
    
    if ([method isEqualToString:kInterfaceGet_tx_info]) {
        NSString *tx_hash = [parameter safeStringForKey:@"tx_hash"];
        result = PyObject_CallMethod(self.pyInstance, [method UTF8String], "s",[tx_hash UTF8String]);
    
    
    }else if([method isEqualToString:kInterfaceCreate_hd_wallet]){
        NSString *password = [parameter safeStringForKey:@"password"];
        NSString *seed = [parameter safeStringForKey:@"seed"];
        if (seed == NULL || seed.length == 0) {
            result = PyObject_CallMethod(self.pyInstance, [kInterfaceCreate_hd_wallet UTF8String], "(s)",[password UTF8String],"");
        }else{
            result = PyObject_CallMethod(self.pyInstance, [kInterfaceCreate_hd_wallet UTF8String], "(s,s)",[password UTF8String],[seed UTF8String]);
        }
        

    
    }else if([method isEqualToString:kInterfaceLoad_wallet]){
        NSString *name = [parameter safeStringForKey:@"name"];
        PyObject_CallMethod(self.pyInstance, [method UTF8String], "(s)",[name UTF8String]);
        result = PyObject_CallMethod(self.pyInstance, [kInterfaceSelect_wallet UTF8String], "(s)",[name UTF8String]);
    
    
    }else if([method isEqualToString:kInterfaceGet_all_tx_list]){
        NSString *search_type = [parameter safeStringForKey:@"search_type"];
        if (search_type == nil || search_type.length == 0) {
            result = PyObject_CallMethod(self.pyInstance, [kInterfaceGet_all_tx_list UTF8String], "");
        }else{
            result = PyObject_CallMethod(self.pyInstance, [kInterfaceGet_all_tx_list UTF8String], "(s)",[search_type UTF8String]);
        }
    
    
    }else if([method isEqualToString:kInterfaceGet_default_fee_status]){
        result = PyObject_CallMethod(self.pyInstance, [kInterfaceGet_default_fee_status UTF8String], "");
    
    
        
    }else if([method isEqualToString:kInterfaceGet_fee_by_feerate]){
        NSString *outputs = [parameter safeStringForKey:@"outputs"];
        NSString *message = [parameter safeStringForKey:@"message"];
        NSString *feerate = [parameter safeStringForKey:@"feerate"];
        result = PyObject_CallMethod(self.pyInstance, [kInterfaceGet_fee_by_feerate UTF8String], "(s,s,i)", [outputs UTF8String],[message UTF8String],[feerate longLongValue]);
    
    
    
    }else if([method isEqualToString:kInterfaceMktx]){
        NSString *outputs = [parameter safeStringForKey:@"outputs"];
        NSString *message = [parameter safeStringForKey:@"message"];
        result = PyObject_CallMethod(self.pyInstance, [kInterfaceMktx UTF8String], "(s,s)", [outputs UTF8String],[message UTF8String]);

    
    
    }else if([method isEqualToString:kInterfaceSign_tx]){
        NSString *tx = [parameter safeStringForKey:@"tx"];
        //NSString *password = [parameter safeStringForKey:@"password"];
        result = PyObject_CallMethod(self.pyInstance, [kInterfaceSign_tx UTF8String], "(s,s)", [tx UTF8String],"");
    
        
    }else if([method isEqualToString:kInterfaceBroadcast_tx]){
        NSString *tx = [parameter safeStringForKey:@"tx"];
        result = PyObject_CallMethod(self.pyInstance, [kInterfaceBroadcast_tx UTF8String], "(s)", [tx UTF8String]);
    }
    
  
    if (result == NULL) {
        PyErr_Print();
    }
    char * resultCString = NULL;
    PyArg_Parse(result, "s", &resultCString); //将python类型的返回值转换为c
    PyGILState_Release(state);
    NSLog(@"%s", resultCString);
    NSString *jsonStrResult = [NSString stringWithCString:resultCString encoding:NSUTF8StringEncoding];
    id object = [jsonStrResult mj_JSONObject];
    if (object == NULL) {
        return jsonStrResult;
    }
    return object;
}
@end
