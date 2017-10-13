/* 
 * Author: Cloudalyze Solutions LLP
 * Class: HierarchyControllerTest
 * Description: Test class for HierarchyController
 * Date: 15th June, 2017
 * Version: 
 * 
 * */


@isTest (seeAllData=false)
public class CorpAccountTest
{
    
    private static Account objAcc;
    private static Account objAccOne;
    private static Project__c objProject;
    private static Project__c objProjectOne;
    private static Project__c objProjectTwo;
    private static Order objOrder;
    private static Quote__c objQuote;
    private static Opportunity objOppy;
    private static List<SelectOption> soList ;
    private static List < Project__c > lstProject = new List < Project__c >();
   
    
    // inserting test data.
    static void testDataSetup(){
        
        objAcc = new Account( Name = 'test name', Type = 'Architecture Firm',
                                     BillingCountry = 'United States', 
                                     BillingState = 'New York', 
                                     BillingPostalCode = '60603'
                            );
        insert objAcc;
        objAccOne = new Account( Name = 'test name', Type = 'Architecture Firm',
                                     BillingCountry = 'United States', 
                                     BillingState = 'New York', 
                                     BillingPostalCode = '60603'
                            );
        insert objAccOne;
        
        objProject = new Project__c(  Name = 'Test Project', Application__c = 'Retail', 
                                      Stage__c = 'Project Created',
                                      Amount__c = 1.2, Purchaser_Account__c = objAcc.Id, 
                                      End_Customer_Account__c = objAcc.Id, Architect_Account__c = objAcc.id, 
                                      Ordering_Account__c = objAcc.Id, Project_Country__c = 'Canada', 
                                      Project_Zip_Code__c = 'T5A0A7'
                                   );
        
        //insert objProject;
        lstProject.add( objProject );
        objProjectOne = new Project__c(  Name = 'Test Project', Application__c = 'Retail', 
                                      Stage__c = 'Project Won - Order Paid',
                                      Amount__c = 1.2, Purchaser_Account__c = objAccOne.Id, 
                                      End_Customer_Account__c = objAccOne.Id, Architect_Account__c = objAccOne.id, 
                                      Ordering_Account__c = objAccOne.Id, Project_Country__c = 'Canada', 
                                      Project_Zip_Code__c = 'T5A0A7'
                                   );
        //insert objProjectOne;
        lstProject.add( objProjectOne );
        objProjectTwo = new Project__c(  Name = 'Test Project', Application__c = 'Retail', 
                                      Stage__c = 'Quoted',
                                      Amount__c = 1.2, Purchaser_Account__c = objAccOne.Id, 
                                      End_Customer_Account__c = objAccOne.Id, Architect_Account__c = objAccOne.id, 
                                      Ordering_Account__c = objAccOne.Id, Project_Country__c = 'Canada', 
                                      Project_Zip_Code__c = 'T5A0A7'
                                   );
        lstProject.add( objProjectTwo );
        //insert objProjectTwo;
        insert lstProject;
        objOppy = new Opportunity( Name = 'Test Opportunity', AccountId = objAcc.Id, 
                                  Project_Name__c = lstProject[0].Id, StageName = 'Opportunity Created', 
                                  ForecastCategoryName='Pipeline', CloseDate = System.today()
                                 );
        insert objOppy;
        objQuote = new Quote__c( Name = 'Test Quote', Opportunity__c = objOppy.id, Project__c = lstProject[0].Id); 
        insert objQuote;
        
        objOrder = new Order( Name = 'Test Order', Status = 'Draft', 
                              AccountId = objAcc.Id, EffectiveDate = System.today(), 
                              Project__c = lstProject[0].Id, NanaQuote__c= objQuote.ID, 
                              Order_Finalized_Date__c = System.today()
                            );
   //      insert objOrder;
    
    }
    
    
    //single record insertion
    static testMethod void recordInsert(){
        
        testDataSetup();    
        ApexPages.StandardController sc = new ApexPages.StandardController(objAcc);
  		CorpAccountHierarchyController objHC = new CorpAccountHierarchyController(sc);
        objHC.ProjectApplicationIndustry = 'Retail';
        PageReference pageRef = Page.CorpAccountHierarchy; // VF Page.
  		pageRef.getParameters().put('id', String.valueOf(objAcc.Id));
        pageRef.getParameters().put('intNumberofPages', '2');
        pageRef.getParameters().put('ProjectApplicationIndustry','Office');
        pageRef.getParameters().put('ordFnzDtMax', '01/01/2016');
        pageRef.getParameters().put('project_drp_Stage', 'Closed Complete - Ordered - Paid'); 
        pageRef.getParameters().put('sortExpression', '');
        pageRef.getParameters().put('accFilter', 'Test Account');
        
        
        Test.setCurrentPage(pageRef);
        // Methods 
        soList = objHC.getStageDrp();
        objHC.setPagination();
        objHC.ProjectSearch();
        objHC.ProjectReset();
        pageRef = objHC.refreshPageSize();

        objHC.filterAcc();
    
        pageRef = objHC.refreshPageSize();

        objHC.filterAcc();
        System.assertEquals( 3, lstProject.size() );
    }
    
    
    static testMethod void newRecordInsert(){
        
        testDataSetup();    
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccOne);
  		HierarchyController objHC = new HierarchyController(sc);
        objHC.appIndFilter = 'Retail';
        PageReference pageRef = Page.CorpAccountHierarchy; // VF Page.
  		pageRef.getParameters().put('id', String.valueOf(objAccOne.Id));
        pageRef.getParameters().put('ordFnzDtMax', '01/01/2016');
        pageRef.getParameters().put('sortExpression', 'ASC');
        System.assertEquals( 3, lstProject.size() );
    }
    
        

}