//
//  APIClient.swift
//  Excursion
//
//  Created by Ambuj Punn on 10/29/16.
//
//

class APIClient: NSObject {
    static let sharedInstance = APIClient()
    fileprivate var rkManager: RKObjectManager?
    
    // Make init inaccessible so nothing else can instantiate APIClient using init
    fileprivate override init() {}
   
    func setBaseUrl(baseUrl url: String) -> Void {
        rkManager = RKObjectManager(baseURL: URL(string: url))
    }
    
    func setupAPI(_ baseUrl: String?, objectMapping: AnyClass, attributeMappings mappings: Dictionary<String, String>, apiPath path: String, keyPath: String) {
        if let url = baseUrl {
            setBaseUrl(baseUrl: url)
            
            let apiObjectMapping = RKObjectMapping(for: objectMapping)
            apiObjectMapping?.addAttributeMappings(from: mappings)
            
            let responseDescriptor = RKResponseDescriptor(mapping: apiObjectMapping, method: .GET, pathPattern: path, keyPath: keyPath, statusCodes: IndexSet(integer: 200))
            rkManager?.addResponseDescriptor(responseDescriptor)   
        }
    }

    func sendAPIRequest(apiPath path: String, queryParams params: Dictionary<String, String>, httpHeaders headers: Dictionary<String, String>, success: @escaping (Array<Any>?) -> Void, failure: @escaping (Error) -> Void) {
        for headersDictionary in headers {
            let httpHeader = headersDictionary.0
            let value = headersDictionary.1
            
            if (httpHeader.characters.count > 0 && value.characters.count > 0) {
                rkManager?.httpClient.setDefaultHeader(httpHeader, value: value)
            }
        }
        #if (TARGET_OS_SIMULATOR)
            rkManager?.httpClient.allowsInvalidSSLCertificate = true
        #endif
        rkManager?.getObjectsAtPath(path, parameters: params,
                                    success: { (operation: RKObjectRequestOperation?, mappingResult: RKMappingResult?) in
                                        success((mappingResult?.array()))
                                    }, failure: { (operation: RKObjectRequestOperation?, error: Error?) in
                                        failure(error!)
                                    }
        )
    }
}
