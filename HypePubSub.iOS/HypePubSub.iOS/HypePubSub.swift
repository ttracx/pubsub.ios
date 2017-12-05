//
//  HypePubSub.swift
//  HypePubSub.iOS
//

import Foundation
import os


class HypePubSub
{
    private static let HYPE_PUB_SUB_LOG_PREFIX = HpsConstants.LOG_PREFIX + "<HypePubSub> "
    
    private static let hps = HypePubSub() // Early loading to avoid thread-safety issues

    var ownSubscriptions: SubscriptionsList
    var managedServices: ServiceManagersList
    
    private let network = Network.getInstance()
    
    public static func getInstance() -> HypePubSub
    {
        return hps
    }
    
    init()
    {
        self.ownSubscriptions = SubscriptionsList()
        self.managedServices = ServiceManagersList()
    }
    
    
    func issueSubscribeReq(_ serviceName: String) -> Int
    {
        /*
        byte serviceKey[] = HpsGenericUtils.getStrHash(serviceName)
        Instance managerInstance = network.determineInstanceResponsibleForService(serviceKey)
    
        // Add subscription to the list of own subscriptions. Only adds if it doesn't exist yet.
        ownSubscriptions.add(serviceName, managerInstance)
    
        // if this client is the manager of the service we don't need to send the subscribe message to
        // the protocol manager
        if(HpsGenericUtils.areInstancesEqual(network.ownClient.instance, managerInstance))
        {
            printIssueReqToHostInstanceLog("Subscribe", serviceName)
            this.processSubscribeReq(serviceKey, network.ownClient.instance)
            return 1
        }
        else
        {
            Protocol.sendSubscribeMsg(serviceKey, managerInstance)
        }
        */
        return 0
    }
    
    func issueUnsubscribeReq(_ serviceName: String) -> Int
    {
        /*
        byte serviceKey[] = HpsGenericUtils.getStrHash(serviceName)
        Instance managerInstance = network.determineInstanceResponsibleForService(serviceKey)
    
        if(ownSubscriptions.find(serviceKey) == null)
        {
            return -2
        }
    
        // Remove the subscription from the list of own subscriptions
        ownSubscriptions.remove(serviceName)
    
        // if this client is the manager of the service we don't need to send the unsubscribe message
        // to the protocol manager
        if(HpsGenericUtils.areInstancesEqual(network.ownClient.instance, managerInstance))
        {
            printIssueReqToHostInstanceLog("Unsubscribe", serviceName)
            this.processUnsubscribeReq(serviceKey, network.ownClient.instance)
        }
        else {
            Protocol.sendUnsubscribeMsg(serviceKey, managerInstance)
        }
        */
        return 0
    }
    
    func issuePublishReq(_ serviceName: String, _ msg: String) -> Int
    {
        /*
        byte serviceKey[] = HpsGenericUtils.getStrHash(serviceName)
        Instance managerInstance = network.determineInstanceResponsibleForService(serviceKey)
        
        // if this client is the manager of the service we don't need to send the publish message
        // to the protocol manager
        if(HpsGenericUtils.areInstancesEqual(network.ownClient.instance, managerInstance))
        {
            printIssueReqToHostInstanceLog("Publish", serviceName)
            this.processPublishReq(serviceKey, msg)
            return 1
        }
        else
        {
            Protocol.sendPublishMsg(serviceKey, managerInstance, msg)
        }
        */
        return 0
    }
    
    // synchronized
    func processSubscribeReq(_ serviceKey: Data, _ requesterInstance: HYPInstance)
    {
        /*
        Instance managerInstance = network.determineInstanceResponsibleForService(serviceKey)
        if( ! HpsGenericUtils.areInstancesEqual(managerInstance, network.ownClient.instance))
        {
            Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX
            + "Another instance should be responsible for the service 0x"
            + BinaryUtils.byteArrayToHexString(serviceKey) + ": "
            + HpsGenericUtils.getInstanceLogIdStr(managerInstance))
            return
        }
    
        ServiceManager serviceManager = this.managedServices.find(serviceKey)
        if(serviceManager == null ) // If the service does not exist we create it.
        {
            Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX
            + "Processing Subscribe request for non-existent ServiceManager 0x"
            + BinaryUtils.byteArrayToHexString(serviceKey)
            + ". ServiceManager will be created.")
    
            this.managedServices.add(serviceKey)
            serviceManager = this.managedServices.getLast()
            updateManagedServicesUI() // Updated UI after adding a new managed
        }
    
        Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX
        + "Adding instance " + HpsGenericUtils.getInstanceLogIdStr(requesterInstance)
        + " to the list of subscribers of the service 0x" + BinaryUtils.byteArrayToHexString(serviceKey))
    
        serviceManager.subscribers.add(requesterInstance)
        */
    }
    
    // synchronized
    func processUnsubscribeReq(_ serviceKey: Data, _ requesterInstance: HYPInstance)
    {
        /*
        ServiceManager serviceManager = this.managedServices.find(serviceKey)
        
        if(serviceManager == null) // If the service does not exist nothing is done
        {
            Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX
            + "Processing Unsubscribe request for non-existent ServiceManager 0x"
            + BinaryUtils.byteArrayToHexString(serviceKey)
            + ". Nothing will be done.")
            
            return
        }
        
        Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX
        + "Removing instance " + HpsGenericUtils.getInstanceLogIdStr(requesterInstance)
        + " from the list of subscribers of the service 0x" + BinaryUtils.byteArrayToHexString(serviceKey))
        
        serviceManager.subscribers.remove(requesterInstance)
        
        if(serviceManager.subscribers.size() == 0)
        { // Remove the service if there is no subscribers
            this.managedServices.remove(serviceKey)
            updateManagedServicesUI() // Updated UI after removing a managed service
        }
        */
    }
    
    // synchronized
    func processPublishReq(_ serviceKey: Data, _ msg: String)
    {
        /*
        ServiceManager serviceManager = this.managedServices.find(serviceKey)
        if(serviceManager == null)
        {
            Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX
            + "Processing Publish request for non-existent ServiceManager 0x"
            + BinaryUtils.byteArrayToHexString(serviceKey)
            + ". Nothing will be done.")
            
            return
        }
        
        ListIterator<Client> it = serviceManager.subscribers.listIterator()
        while(it.hasNext())
        {
            Client client = it.next()
            if(client == null)
            continue
            
            if(HpsGenericUtils.areInstancesEqual(network.ownClient.instance, client.instance))
            {
                Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX
                + "Publishing info from service 0x" + BinaryUtils.byteArrayToHexString(serviceKey)
                + " to Host instance")
                
                this.processInfoMsg(serviceKey, msg)
            }
            else{
                
                Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX
                + "Publishing info from service 0x" + BinaryUtils.byteArrayToHexString(serviceKey)
                + " to " + HpsGenericUtils.getInstanceLogIdStr(client.instance))
                
                Protocol.sendInfoMsg(serviceKey, client.instance, msg)
            }
        }
         */
    }
    
    func processInfoMsg(_ serviceKey: Data, _ msg: String)
    {
        /*
        Subscription subscription = ownSubscriptions.find(serviceKey)
        
        if(subscription == null){
            Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX
            + "Info received from the unsubscribed service"
            + BinaryUtils.byteArrayToHexString(serviceKey) + ": " + msg)
            return
        }
        
        Date now = new Date()
        SimpleDateFormat sdf = new SimpleDateFormat("k'h'mm", Locale.getDefault())
        String timestamp = sdf.format(now)
        String msgWithTimeStamp = timestamp + ": " + msg
        
        subscription.receivedMsg.add(0, msgWithTimeStamp)
        updateMessagesUI()
        String notificationText = subscription.serviceName + ": " + msg
        displayNotification(MainActivity.getContext(), HpsConstants.NOTIFICATIONS_CHANNEL, HpsConstants.NOTIFICATIONS_TITLE, notificationText, notificationID)
        notificationID++
        
        Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX
        + "Info received from the unsubscribed service"
        + subscription.serviceName + ": " + msg)
        */
    }
    
    // synchronized
    func updateManagedServices()
    {
        /*
        Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX + "Executing updateManagedServices ("
        + this.managedServices.size() + " services managed)")
    
        ListIterator<ServiceManager> it = this.managedServices.listIterator()
    
        while(it.hasNext())
        {
            ServiceManager managedService = it.next()
        
            // Check if a new Hype client with a closer key to this service key has appeared. If this happens
            // we remove the service from the list of managed services of this Hype client.
            Instance newManagerInstance = network.determineInstanceResponsibleForService(managedService.serviceKey)
        
            Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX + "Analyzing ServiceManager from service 0x"
            + BinaryUtils.byteArrayToHexString(managedService.serviceKey))
        
            if( ! HpsGenericUtils.areInstancesEqual(newManagerInstance, network.ownClient.instance))
            {
                Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX
                + "The service 0x" + BinaryUtils.byteArrayToHexString(managedService.serviceKey)
                + " will be managed by: " + HpsGenericUtils.getInstanceLogIdStr(newManagerInstance)
                + ". ServiceManager will be removed")
            
                it.remove()
            }
        }
        */
    }
    
    // synchronized
    func updateOwnSubscriptions()
    {
        /*
        Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX + "Executing updateOwnSubscriptions ("
        + this.ownSubscriptions.size() + " subscriptions)")
    
        ListIterator<Subscription> it = this.ownSubscriptions.listIterator()
        while(it.hasNext())
        {
            Subscription subscription = it.next()
    
            Instance newManagerInstance = network.determineInstanceResponsibleForService(subscription.serviceKey)
    
            Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX
            + "Analyzing subscription " + HpsGenericUtils.getSubscriptionLogStr(subscription))
    
            // If there is a node with a closer key to the service key we change the manager
            if( ! HpsGenericUtils.areInstancesEqual(newManagerInstance, subscription.manager))
            {
                Log.i(TAG, HYPE_PUB_SUB_LOG_PREFIX
                + "The manager of the subscribed service " + subscription.serviceName
                + " has changed: " + HpsGenericUtils.getInstanceLogIdStr(newManagerInstance)
                + ". A new Subscribe message will be issued")
    
                subscription.manager = newManagerInstance
                this.issueSubscribeReq(subscription.serviceName) // re-send the subscribe request to the new manager
            }
        }
        */
    }
    
    
    //////////////////////////////////////////////////////////////////////////////
    // Logging Methods
    //////////////////////////////////////////////////////////////////////////////
    
    static func printIssueReqToHostInstanceLog(_ msgType: String, _ serviceName: String)
    {
        os_log("%@ Issuing %@ for service %@", log: OSLog.default, type: .info,
               HYPE_PUB_SUB_LOG_PREFIX, msgType, serviceName)
    }
}
