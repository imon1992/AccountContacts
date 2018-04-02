public class AccountWithContactsControllerHelper {
    
    private Map<String,Boolean> fieldsAcces;
    private Map<String,String> whereParamsMap;
    private List<SObject> sObjectList;
    private String objectName;
    
    
    public AccountWithContactsControllerHelper(String objectName){
        this.objectName = objectName;
    }
    public void setwhereParamsMap(Map<String,String> whereParamsMap){
        this.whereParamsMap = whereParamsMap;
    }
    
    public Map<String,Boolean> getFieldsAcces(String accessType, List<String> fieldsToCheck){
        fieldsAcces = ObjectAndFieldsAccessCheck.checkAccessToObjectFields(objectName,accessType,fieldsToCheck);
        return fieldsAcces;
    }
    
    public Map<String,Boolean> getActionAccess(){
        String[] aviliableActionForCheck = new List<String> {'isCreateable','isUpdateable','isDeletable'};
            Map<String,Boolean> aviliableAction = new Map<String,Boolean>();
        for(String action : aviliableActionForCheck){
            aviliableAction.put(action,ObjectAndFieldsAccessCheck.checkAccessToObject(objectName,action));
        }
        return aviliableAction;
    }

    public String getSoql(String innerSoql){
        String[] fieldsForSelect = new List<String>();
        fieldsForSelect.addAll(fieldsAcces.keySet());
        SimpleSOQLBuilder newSoqlQuery = new SimpleSOQLBuilder();
        Integer counterForQuery = 0;
        if(fieldsForSelect != null){
            newSoqlQuery.addSelect(fieldsForSelect,innerSoql);
            counterForQuery++;
        }
        if(objectName != null){
            newSoqlQuery.addFrom(objectName,innerSoql);
            counterForQuery++;
        }
        if(whereParamsMap != null){
            newSoqlQuery.addWhere(whereParamsMap);
        }
        return newSoqlQuery.SOQLPart;
    }
    
    // public List<SObject> getSObjectByAccessibleFields(){
    //     // String[] fieldsForSelect = new List<String>();
    //     // fieldsForSelect.addAll(fieldsAcces.keySet());
    //     // SimpleSOQLBuilder newSoqlQuery = new SimpleSOQLBuilder();
    //     // Integer counterForQuery = 0;
    //     // if(fieldsForSelect != null){
    //     //     newSoqlQuery.addSelect(fieldsForSelect,innerSoql);
    //     //     counterForQuery++;
    //     // }
    //     // if(objectName != null){
    //     //     newSoqlQuery.addFrom(objectName,innerSoql);
    //     //     counterForQuery++;
    //     // }
    //     // if(whereParamsMap != null){
    //     //     newSoqlQuery.addWhere(whereParamsMap);
    //     // }
        
    //     // if(counterForQuery >= 2){
    //     //     return Database.query(newSoqlQuery.SOQLPart);
    //     // }
    //     return null;
    // }
}