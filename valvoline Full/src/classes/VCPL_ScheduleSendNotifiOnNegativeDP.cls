global class VCPL_ScheduleSendNotifiOnNegativeDP implements Schedulable{	
    global void execute(SchedulableContext sc)
    {
        VCPL_SendNotificationOnNegativeDP objBatch = new VCPL_SendNotificationOnNegativeDP();
        Database.executeBatch(objBatch);
    }  
}