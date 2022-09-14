trigger trg3 on Opportunity(after update,after Insert,after Delete)
{
    Set<Id> accId = new Set<Id>();
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate))
    {
        if(!trigger.new.isEmpty())
        {
            for(Opportunity o : trigger.new)
            {
                if(o.AccountId != null)
                {
                    accId.add(o.AccountId);
                }
            }
        }
    }
    
    if(trigger.isAfter && trigger.isDelete)
    {
        if(!trigger.old.isEmpty())
        {
            for(Opportunity o : trigger.old)
            {
                if(o.AccountId != null)
                {
                    accId.add(o.AccountId);
                }
            }
        }
    }
    
 List<Account> accList = [Select Id,maxOpp__c,(Select Name, Amount from Opportunities where Amount != null order by Amount desc limit 1) from Account 
                         where Id IN : accId];
    
 List<Account> acctList = new List<Account>();
    
    for(Account acc : accList)
    {
        acc.maxOpp__c = acc.Opportunities[0].Name;
        acctList.add(acc);
    }
    
    if(!acctList.isEmpty())
    {
        update acctList;
    }
  
}
