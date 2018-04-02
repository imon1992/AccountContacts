public with sharing class SimpleSOQLBuilder {
    
    public String SOQLPart;
    
    public SimpleSOQLBuilder(){
        SOQLPart = '';
    }
    
    public void addSelect(List<String> fieldsToSelect,String innerSOQL){
        Integer fieldsCount = fieldsToSelect.size();
        String selectPart = 'SELECT ';
        for(Integer i=0;i<fieldsCount;i++)
        {
            if(fieldsCount == (i+1))
            {
                // selectPart +=   fieldsToSelect[i];
                if(innerSOQL ==null){
                    selectPart +=  fieldsToSelect[i] + ',(InnerSoql)';
                }else{
                    selectPart +=   fieldsToSelect[i];
                }
            }else
            {
                // if(innerSOQL ==null){
                    // selectPart +=  fieldsToSelect[i] + ',' + '(InnerSoql)';
                // }else{
                    selectPart +=  fieldsToSelect[i] + ',';
                // }
            }
        }
        SOQLPart += selectPart;
    }
    
    public void addFrom(String tableName,String innerSOQL)
    {
        String fromPart = ' FROM ';
        if(innerSOQL !=null){
            fromPart += tableName +'s';
        }else{
            fromPart += tableName;
        }
            SOQLPart += fromPart;
        
    }
    public void addWhere(Map<String,String> fieldsWithParamsMap)
    {
        Integer fieldsCount = fieldsWithParamsMap.size();
        String wherePArt = ' WHERE ';
        Integer i = 0;
        for(String fieldName:fieldsWithParamsMap.keySet()){
            if(fieldsCount == (i+1))
            {
                wherePArt +=  fieldName + ' = \'' +  fieldsWithParamsMap.get(fieldName) + '\'';
            }else
            {
                wherePArt +=  fieldName + ' = \'' +  fieldsWithParamsMap.get(fieldName) + '\'' + ' AND ';
            }
            i++;
        }
        SOQLPart += wherePArt;
    }
}