trigger trg2 on Contact(after Insert,after Update,after Delete,after Undelete)
{
    Set<Id> accId = new Set<Id>();
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isUndelete))
    {
        if(!trigger.new.isEmpty())
        {
            for(Contact c : trigger.new)
            {
                if(c.AccountId != null)
                {
                    accId.add(c.AccountId);
                }
            }
        }
    }
    
    if(trigger.isAfter && trigger.isDelete)
    {
        if(!trigger.old.isEmpty())
        {
            for(Contact c : trigger.old)
            {
                if(c.AccountId != null)
                {
                    accId.add(c.AccountId);
                }
            }
        }
    }
    
    if(trigger.isAfter && trigger.isUpdate)
    {
        if(!trigger.new.isEmpty())
        {
            for(Contact c : trigger.new)
            {
                if(c.AccountId != trigger.oldMap.get(c.Id).AccountId)
                {
                    
                        accId.add(trigger.oldMap.get(c.Id).AccountId);
                }
                if(c.AccountId != null)
                {
                    accId.add(c.AccountId);
                }
            }
        }
    }
    List<Account> accList = [Select Id,nop__c,(Select Id from Contacts) from Account where Id IN : accId];
    
    for(Account acc : accList)
    {
        acc.nop__c = acc.Contacts.size();
    }
    
    if(!accList.isEmpty())
    {
        update accList;
    }
}
