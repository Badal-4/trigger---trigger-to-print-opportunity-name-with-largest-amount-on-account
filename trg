//trigger to print opportunity with max amount on parent account object
trigger trg3 on Opportunity(after Insert,after Update,after Delete)
{
    Set<Id> accId = new Set<Id>();
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate))
    {
        if(!trigger.new.isEmpty())
        {
            for(Opportunity op : trigger.new)
            {
                if(op.AccountId != null)
                {
                    accId.add(op.AccountId);
                }
            }
        }
    }
    
    if(trigger.isAfter && trigger.isDelete)
    {
        if(!trigger.old.isEmpty())
        {
            for(Opportunity op : trigger.old)
            {
                if(op.AccountId != null)
                {
                    accId.add(op.AccountId);
                }
            }
        }
    }
    
    List<Account> accList = [Select Id,maxOpp__c,(Select Amount,Name from Opportunities where Amount != null
                                                 order by amount desc limit 1) from Account where Id IN : accId];
    List<Account> acctList = new List<Account>();
    
   
        for(Account acc : accList)
        {
            if(!acc.Opportunities.isEmpty())
            {
            acc.maxOpp__c = acc.Opportunities[0].Name;
            acctList.add(acc);
            }
            else 
            {
                acc.maxOpp__c = '';
                acctList.add(acc);
            }
        }
    
    
    if(!acctList.isEmpty())
    {
        update acctList;
    }
}
