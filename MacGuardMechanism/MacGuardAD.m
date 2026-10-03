//
//  macGuardAD.m
//  macGuard
//
//  Created by Jithin Renny Mathew on 22/02/26.
//

#import <Foundation/Foundation.h>

#import "MacGuardAD.h"
#import "MacGuard-Swift.h"

MacGuardAD *authorizationPlugin = nil;
os_log_t pluginLog = nil;

static OSStatus PluginDestroy(AuthorizationPluginRef inPlugin) {
    return [authorizationPlugin PluginDestroy:inPlugin];
}

static OSStatus MechanismCreate(AuthorizationPluginRef inPlugin,
                                AuthorizationEngineRef inEngine,
                                AuthorizationMechanismId mechanismId,
                                AuthorizationMechanismRef *outMechanism) {
    return [authorizationPlugin MechanismCreate:inPlugin
                                      EngineRef:inEngine
                                    MechanismId:mechanismId
                                   MechanismRef:outMechanism];
}

static OSStatus MechanismInvoke(AuthorizationMechanismRef inMechanism) {
    return [authorizationPlugin MechanismInvoke:inMechanism];
}

static OSStatus MechanismDeactivate(AuthorizationMechanismRef inMechanism) {
    return [authorizationPlugin MechanismDeactivate:inMechanism];
}

static OSStatus MechanismDestroy(AuthorizationMechanismRef inMechanism) {
    return [authorizationPlugin MechanismDestroy:inMechanism];
}

static AuthorizationPluginInterface gPluginInterface = {
    kAuthorizationPluginInterfaceVersion,
    &PluginDestroy,
    &MechanismCreate,
    &MechanismInvoke,
    &MechanismDeactivate,
    &MechanismDestroy
};

extern OSStatus AuthorizationPluginCreate(const AuthorizationCallbacks *callbacks,
                                          AuthorizationPluginRef *outPlugin,
                                          const AuthorizationPluginInterface **outPluginInterface) {
    if (authorizationPlugin == nil) {
        authorizationPlugin = [[MacGuardAD alloc] init];
    }
    
    pluginLog = os_log_create("menu.nomad.noload", "Plugin");
    return [authorizationPlugin AuthorizationPluginCreate:callbacks
                                                PluginRef:outPlugin
                                          PluginInterface:outPluginInterface];
}

// Implementation

/**
 C implimentation of the actual authorization plugin since this is all a huge pain in Swift.
 */
@implementation MacGuardAD

- (OSStatus)AuthorizationPluginCreate:(const AuthorizationCallbacks *)callbacks
                            PluginRef:(AuthorizationPluginRef *)outPlugin
                      PluginInterface:(const AuthorizationPluginInterface **)outPluginInterface {
    PluginRecord *plugin = (PluginRecord *) malloc(sizeof(*plugin));
    if (plugin == NULL) return errSecMemoryError;
    plugin->fMagic = kPluginMagic;
    plugin->fCallbacks = callbacks;
    *outPlugin = plugin;
    *outPluginInterface = &gPluginInterface;
    return errSecSuccess;
}

- (OSStatus)MechanismCreate:(AuthorizationPluginRef)inPlugin
                  EngineRef:(AuthorizationEngineRef)inEngine
                MechanismId:(AuthorizationMechanismId)mechanismId
               MechanismRef:(AuthorizationMechanismRef *)outMechanism {
    MechanismRecord *mechanism = (MechanismRecord *)malloc(sizeof(MechanismRecord));
    if (mechanism == NULL) return errSecMemoryError;
    mechanism->fMagic = kMechanismMagic;
    mechanism->fEngine = inEngine;
    mechanism->fPlugin = (PluginRecord *)inPlugin;
    mechanism->fMechID = mechanismId;
    mechanism->ftotpVerifier = (strcmp(mechanismId, "TOTPVerifier") == 0);
    *outMechanism = mechanism;
    
    os_log_debug(pluginLog, "NoLoPlugin:MechanismCreate: inPlugin=%p, inEngine=%p, mechanismId='%{public}s'", inPlugin, inEngine, mechanismId);
    return errSecSuccess;
}

- (OSStatus)MechanismInvoke:(AuthorizationMechanismRef)inMechanism {

    MechanismRecord *mechanism = (MechanismRecord *)inMechanism;
    os_log_debug(pluginLog, "NoLoPlugin:MechanismInvoke: mechMem=%p mechanismId='%{public}s'", inMechanism, mechanism->fMechID);
    
    // Default "Allow Login". Used if none of the mechanisms above are called or don't make
    // a decision
    if (mechanism->ftotpVerifier) {
        NSLog(@"Calling CheckAD");
        TOTPVerifierMechanism *totpVerifier = [[TOTPVerifierMechanism alloc] initWithMechanism:mechanism];
        [totpVerifier run];
        
    }
    
    return noErr;
}

- (OSStatus)MechanismDeactivate:(AuthorizationMechanismRef)inMechanism {
    OSStatus err;
    MechanismRecord *mechanism = (MechanismRecord *)inMechanism;
    os_log_debug(pluginLog, "NoLoPlugin:MechanismDeactivate: mechMem=%p mechanismId='%{public}s'", inMechanism, mechanism->fMechID);
    
    err = mechanism->fPlugin->fCallbacks->DidDeactivate(mechanism->fEngine);
    return err;
}

- (OSStatus)MechanismDestroy:(AuthorizationMechanismRef)inMechanism {
    MechanismRecord *mechanism = (MechanismRecord *)inMechanism;
    free(mechanism);
    return noErr;
}

- (OSStatus)PluginDestroy:(AuthorizationPluginRef)inPlugin {
    free(inPlugin);
    return noErr;
}

@end

