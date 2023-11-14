// Challenge 12 - Bulkification
// Calcular os números de dias com a quantidade em massa de casos de Conta
public class AccountBulkController {
    public static void updateAvgCaseResolutionDays(List<Id> accountId){
        Map<Id, Integer> accTotalCasesMap = new Map<Id, Integer>();
        Map<Id, Integer> accTotalCasesDaysMap = new Map<Id, Integer>();
        // retrive all the cases for this account
        // get resolution days for each account (ClosedDate - CreatedDate)
        for(Case caseObj : [SELECT Id, CreatedDate, ClosedDate, AccountId
                            FROM Case
                            WHERE IsClosed=true
                            AND AccountId =: accountId]){
                                //Verify if this map do not contain any accountId and then add the index                             
                                if(!accTotalCasesMap.containsKey(caseObj.AccountId)){
                                    accTotalCasesMap.put(caseObj.AccountId, 0);
                                    accTotalCasesDaysMap.put(caseObj.AccountId, 0);
                                }  
                                //Get these cases in this Map, after increase number of cases
                                Integer totalCases = accTotalCasesMap.get(caseObj.AccountId);                              
                                totalCases++;
                                accTotalCasesMap.put(caseObj.AccountId, totalCases);
                                // get duration in days and add it to totalDays
                                Integer totalDays = accTotalCasesDaysMap.get(caseObj.AccountId);
                                totalDays += caseObj.CreatedDate.date().daysBetween(caseObj.ClosedDate.date());
                                accTotalCasesDaysMap.put(caseObj.AccountId, totalDays);
                            }
        //get the all accounts in a list 
        List<Account> lstAccounts = new List<Account>();
        // update account object getting all the references in these Maps
        for(Id accId: accTotalCasesDaysMap.keySet()){
            Decimal resolutionDays = accTotalCasesDaysMap.get(accId)/accTotalCasesMap.get(accId);
            lstAccounts.add(new Account(Id = accId, Avg_Case_Resolution_Days__c = resolutionDays));
        }
        update lstAccounts;
    }
}

/*
Execute in anonimous window:

List<Account> recordAll = [SELECT Id, Name FROM Account];
List<Id> allIds = new List<Id>();

for(Account acc: recordAll){
    allIds.add(acc.Id);
    System.debug('All accounts: ' + allIds);
}

AccountBulkController.updateAvgCaseResolutionDays(allIds);
*/