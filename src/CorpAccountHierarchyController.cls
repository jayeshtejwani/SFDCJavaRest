public class CorpAccountHierarchyController 
{    
   
  //  public String status{get;set;}
     /*Filter List*/
    Public List<Projectwrapper> filterList{get;set;}
    public integer projectcount{get;set;}
   
    /*-----*/
     public List<Projectwrapper> lstOpp{get;set;} 
    // Count The Project Won
        public integer ProjWon{get;set;}
    // Count The Project Order In Process
        public integer ProjOrderInProgress{get;set;}
    // Count The Project quote In Process
        public integer ProjQuoteInProgress{get;set;}
    // Count The Project Lost
        public integer ProjLost{get;set;}
    // Count The Project Duplicate
        public integer ProjDuplicate{get;set;}
    // Count The Project Closer Rate Percantage 
        public integer ProjClosureRate{get;set;}
    // Count The Project Amount Won
        public Decimal ProjAmountWon{get;set;}
    // Count The Project Amount in Process
        public Decimal ProjAmountOrderInProgress{get;set;}
    // Count The Project Won
        public Decimal ProjAmounQuoteInProgress{get;set;}
    // Count The Project Won
        public Decimal ProjAmountLost{get;set;}
    // Count The Project Total Amount
        public decimal ProjTotalAmount{get;set;}     
    
        // Latest Order Finalaize Date
        public list<order> latestOrderDate {get;set;}
 	   public date projectLatestDate {get;set;}
       // Store all the data ragarding Account which have project except contact role 
  //      public   list <project__c> AccountWithProjects{get;set;}
        // Account the number site on particular account
         public integer SiteCount {get;set;}
        // hold the value for the queotelss account
        public List<Opportunity> CAProjOppList{get;set;}
        // get run time id of the account 
        public id AccId{get;set;}
        //Pagination varibles and List
        public integer PaginationSize {get;set;}
        public integer NoOfRecords {get;set;}
        // record select options for pagination Account which does not have projects
        public List<selectoption> PaginationSizeOptions ;  
        
        
        /* wrapper class related varieble declaration    */
        
      // store opportunity realted to the  project__C to Find Opportunity Contact Role
        public list<opportunity> oppContactRole; 
        
        // store contact role related to the project role
        public list<opportunityContactRole> ContactRole; 
        
      
        
        
        // combine data project records and related to contact name  
    public  list<Projectwrapper> WrapperCombineAllData{get;set;}
        
    // map hold project id and  related contact role  
    public map<id, list<opportunitycontactrole>> OppContRole; 
    
    
     public list<opportunity>contactName {get;set;}
      public map<id,list<opportunitycontactrole>> NewoppData;
      
      
      // For sorting varieble used in wrapper class
    //   public static String compareField {get; set;}
  //     public static String sortOrder{get; set;} 
    
    
    /*        Varible Declaration related to the Project Filtering        */
    /*                                                                   */
        public String AccountName{get;set;}
        public String ProjectName{get;set;}
        public String ProjectCity{get;set;}
        public String ProjectState{get;set;}
        public String ProjecctZipCode{get;set;}
        public String ProjectStage{get;set;}
        public String ProjectApplicationIndustry{get;set;}
        public String ProjectArchitectAcc{get;set;}
        public String ProjectInstalledAtAcc{get;set;}
        public String ProjectOrderingAcc{get;set;}
        public integer cnt{get;set;}
        public List <Account> AccSiteList{get;set;}
         Public String project_drp_Stage{get;set;}

    // list to hold original vlaue when customer click on search option
    public map<id,Projectwrapper> SearchProject{get;set;}
  
    // Store Account With Prpject data temoorerly
    public list<projectWrapper> SearchProj{get;set;}
     
    
    /* Varible inilization related to Account with Project Pagination */
    
     // Map stores all the records queried as per the pagenumber  
      
      Map<integer,List<Projectwrapper>> mapOpportunityPages = new Map<integer,List<Projectwrapper>>();   
 /*    
        // Pagenumber  
                public integer intPageNumber{get;set;}  
   
   // total number of pages  
           public integer intNumberofPages{get;set;}     
    
    // Wrapper list which Display data on to the Visaulforrce page account with project section  
  
  public List<Projectwrapper> getLstOppRecords()
   
   {  
         lstOpp= new List<Projectwrapper>();  
        // List<Projectwrapper> lstOpp= new List<Projectwrapper>();  
       if(intPageNumber==null){
           intPageNumber = 2;
       }
         lstOpp.addAll(mapOpportunityPages.get(intPageNumber));  
       
         return lstOpp;  
   }  
    */
       
  
       // Main class Constructor for all data inilization
        public  CorpAccountHierarchyController(ApexPages.StandardController setCon) 
        {
           
            
            AccId = ApexPages.currentPage().getParameters().get('id');
            
            // Inilize all summary Account Data to the Zero
            ProjWon =0;
            ProjOrderInProgress =0;
            ProjQuoteInProgress=0;
            ProjLost=0;
            ProjQuoteInProgress=0;            
            ProjDuplicate=0;
            ProjClosureRate=0;
            ProjAmountWon=0;
            ProjAmountOrderInProgress=0;
            ProjAmounQuoteInProgress=0;
            ProjAmountLost=0;
            ProjTotalAmount=0;
            
            
            // Varible Inilization related to the wrapper class
            
            oppContactRole = new list<opportunity>();
            OppContRole =new map<id, list<opportunitycontactrole>>();
            ContactRole = new list<opportunityContactRole>();
            WrapperCombineAllData = new list<projectWrapper>();
            contactName = new list<opportunity>();
            NewoppData = new  map<id,list<opportunitycontactrole>>();
     
            projectLatestDate = null;
           
            // Pagination Default Page Size 
            PaginationSize =10;
            
            // User Can select Pagination Size from this options
            paginationSizeOptions = new List<selectoption>();
            
            // Page size options on Account which does not have project
            paginationSizeOptions.add(new selectoption('25','25'));
            paginationSizeOptions.add(new selectoption('100','100'));
            paginationSizeOptions.add(new selectoption('150','150'));
            paginationSizeOptions.add(new selectoption('200','200'));
            paginationSizeOptions.add(new selectoption('250','250'));
            
            
            
            // Varieble Inilization Related to the Filtering Section 
            
        project_drp_Stage = '';    
        ProjectName= '';
        AccountName= '';
        ProjectCity= '';
        ProjectState= '';
        ProjecctZipCode= '';
        ProjectStage= '';
        ProjectApplicationIndustry= '';
        ProjectArchitectAcc= '';
        ProjectInstalledAtAcc= '';
        ProjectOrderingAcc= '';
        cnt=0;
        AccSiteList = new List <Account>();
        filterList = new List<Projectwrapper>();
        
            
      
      // Function call to summary Section 
      
       setPagination();
            
           
            
            
          // project related records store while filtering
            
         SearchProject =new map<id,Projectwrapper>();
         SearchProj = new list<projectwrapper>();
                    
        // Account with project size to display on summary section
                    
           projectcount=WrapperCombineAllData.size();
        }
    
   // function which fires query store account with project related data in to the list 
   
   public void setPagination() 
    {
      
        // Count the total Site of the projects
            SiteCount=[select count() from account where parent.id =:accid];
            
            
             
            //get the latest order finalize Date from orders
            latestOrderDate  = [select Order_Finalized_Date__c, project__r.Purchaser_Account__c, account.id from order where (project__r.Purchaser_Account__c=:AccId OR project__r.End_Customer_Account__c=:AccId OR project__r.Architect_Account__c=:AccId OR project__r.Brand_Name_Account__c=:AccId  OR project__r.Franchise_Account__c = :AccId OR project__r.Franchisor_Account__c = :AccId OR project__r.Other_Influencer_Account__c = :AccId OR project__r.Ordering_Account__c =:AccId)   AND Order_Finalized_Date__c!=null order By Order_Finalized_Date__c DESC LIMIT 1]; 
           if(latestOrderDate.size()==1)
           {
        	projectLatestDate =latestOrderDate[0].Order_Finalized_Date__c;
           }
        else
        {
            projectLatestDate=null ;
        
        }
            // Fire Query on Project Object and get all related data except contact Role
               
               String query1 ='SELECT (Select CreatedDate, Order_Finalized_Date__c From Orders__r), Architect_Contact__r.firstname,Name, Architect_Account__r.Name, Purchaser_Account__r.Name, Ordering_Account__r.Name, CreatedDate,Application__c, Amount__c, Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c,';
               query1+='Architect_Account__c,Ordering_Account__c,  End_Customer_Account__c,End_Customer_Account__r.Name, Franchise_Account__c,   Purchaser_Account__c, ';
               query1+='(Select Id from Opportunities__r where (StageName like \'%Won%\' OR StageName like \'%Complete%\' OR StageName like \'%Paid%\') AND (NOT StageName LIKE \'%Influencer%\')AND (Project_Name__r.Ordering_Account__c!=Null))';
               query1+=' FROM Project__c ';
               query1+=' WHERE (Architect_Account__c = :AccId OR Brand_Name_Account__c = :AccId OR End_Customer_Account__c = :AccId '; 
               query1+=' OR Franchise_Account__c = :AccId OR Franchisor_Account__c = :AccId OR Other_Influencer_Account__c = :AccId '; 
               query1+=' OR Purchaser_Account__c =:AccId OR Ordering_Account__c =:AccId ) order by createddate DEsc ';
            
           
           // temporary store data into the list 
                
            list<project__c> projectData  =database.query(query1);
      
                 
     /*********QuoteLess Opprotunities *******************/
        CAProjOppList = [select id, name, stagename , Quote_Count__c,Project_Name__r.Name, Project_Name__r.Purchaser_Account__c,Project_Name__r.Architect_Account__c,Project_Name__r.CreatedDate,Project_Name__r.Bid_Date__c,Project_Name__r.Award_Date__c,Project_Name__r.Close_Date__c,Project_Name__r.Actual_Project_Need_Date__c,Project_Name__r.Amount__c,Project_Name__r.Estimated_Project_Need_Date__c  from opportunity where (stagename='Opportunity Created' ) AND Project_Name__r.Purchaser_Account__c =:AccId AND Quote_Count__c=0];
     /**********End Section *****************************/  
        
        // stores opportunity associate with the project 
        
        for(project__C prj : projectData)
        {
            
            oppContactRole.addAll(prj.opportunities__r);
            
            
        }
        
        
        // select contact name associate with opportunity
        
         contactName=[select project_name__c,(select contact.name from OpportunityContactRoles) from opportunity where id IN :oppContactRole];  
        
   
       // Made Map that Map project id with OpportunityContactRole Name
            
            for(opportunity  aa: contactName)
                
                {
                      
                        if(NewoppData.containsKey(aa.project_name__c))
                      
                        {
                      
                            NewoppData.get(aa.project_name__c).addAll(aa.OpportunityContactRoles);
                        }
                   
                    else
                   
                        NewoppData.put(aa.project_name__c, aa.OpportunityContactRoles);
                
                }  
                
                
        
                 
             // counting summary section Data    
                 
                 for(Project__c proj: projectData )
           
            
            {
            
                   
           
            //Project Lost//       
                
            if(proj.Stage__c.contains('Project Lost') || proj.Stage__c.contains('Project Inactive') || proj.Stage__c.contains('Cancelled'))
                       
                       {
             
                               
                                   ProjLost= ProjLost+ 1; 
                                   if(proj.Amount__c!=NULL)
                                   {
                                    
                                        ProjAmountLost =ProjAmountLost + proj.Amount__c;
                                   
                                   }
              
                     } 
                
            
            // Count Duplicate Projects
            
                     if(proj.Stage__c.contains('Duplicate'))
                     
                    {
                    
                            ProjDuplicate= ProjDuplicate+1;
                    
                    }   
            
                //Project Won(Order Paid)//
            if (proj.Stage__c != null && (proj.Stage__c.contains('Project Won - Order Paid')))
               
                {
                    
                    ProjWon = ProjWon + 1;
                    ProjAmountWon= ProjAmountWon+ proj.Amount__c; 
                    
                    
                }
                
             //Project (Order In Progress)//   
            if(proj.Stage__c.contains('Order Finalized') || proj.Stage__c.contains('Order Pending') || proj.Stage__c.contains('Project On Hold') && proj.Orders__r.size()>0)
              
                {
                          
                            ProjOrderInProgress = ProjOrderInProgress +1; 
                    
                        if(proj.Amount__c!=null)
                        {    
                    
                                ProjAmountOrderInProgress= ProjAmountOrderInProgress+ proj.Amount__c; 
                         } 
                            
                }
                
             
                 /** Total Amount related to Amount (Quote In Progress)****/ 
          
          
            if(proj.Stage__c.contains('Quoted') || proj.Stage__c.contains('Budget Quote-Influencer') || proj.Stage__c.contains('Budget Quote-Purchaser') || proj.Stage__c.contains('Project Created') || (proj.Stage__c.contains('Project On Hold') && proj.Orders__r.size()==0))
          
            {
                
                ProjQuoteInProgress= ProjQuoteInProgress+ 1;
                
                        if(proj.Amount__c!=NULL)
                
                        {
                                
                                ProjAmounQuoteInProgress= ProjAmounQuoteInProgress+ proj.Amount__c;
                        }
          
           }
           
          
         if(proj.Amount__c!=NULL)
         
                 {
                            ProjTotalAmount= ProjTotalAmount+ proj.Amount__c;
            
                 }
                
                
           // check project id into the map to bind project object record with opportunitycontactRole     
                
                if (NewoppData.containsKey(proj.id))
  
                            {
                           
                                    list<opportunitycontactrole> OCR = NewoppData.get(proj.id);
                                    Projectwrapper wrapper = new Projectwrapper(proj, OCR);                                        
                                    this.WrapperCombineAllData.add(wrapper); 
                            }  
                            
                            
                  else
                  
                  {
                          
                                              Projectwrapper wrapper1 = new Projectwrapper(proj, NewoppData.get(proj.id));
                                              this.WrapperCombineAllData.add(wrapper1);
                                              
                  
                  }                

  
            }
    
    
}
    
    integer Flag=0;
      /*  Funtions for Project Search and return result */
    
       public void ProjectSearch()
  
     {
                 
                 if(Flag==0)
                  
                 {
                     SearchProj.addall(WrapperCombineAllData); 
                     Flag++;
                 
                 }      
                   
                      
                  
        
        WrapperCombineAllData.clear();
        
                 
                 system.debug('The value of innerAsshok ::::' +SearchProj.size());     
                        
            for(Projectwrapper  hr: SearchProj)                     
            
            {
                       
                            integer flag = 0;
                            cnt = 0;
            
                            if(AccountName!=''){AccountName = AccountName.trim(); cnt++;} 
                            if(ProjectName!='' ){ProjectName = ProjectName.trim(); cnt++;} 
                            if(ProjectCity!=''){ProjectCity = ProjectCity.trim(); cnt++;} 
                            if(ProjectState!=''){ProjectState = ProjectState.trim(); cnt++;} 
                            if(ProjecctZipCode!=''){ProjecctZipCode = ProjecctZipCode.trim(); cnt++;}
                            if(ProjectApplicationIndustry!=''){ProjectApplicationIndustry = ProjectApplicationIndustry.trim(); cnt++;}
                            if(project_drp_Stage!='' && project_drp_Stage!='None'){project_drp_Stage = project_drp_Stage.trim(); cnt++;}
                            if(ProjectArchitectAcc!=''){ProjectArchitectAcc = ProjectArchitectAcc.trim(); cnt++;}
                            if(ProjectInstalledAtAcc!=''){ProjectInstalledAtAcc = ProjectInstalledAtAcc.trim(); cnt++;}
                            if(ProjectOrderingAcc!=''){ProjectOrderingAcc = ProjectOrderingAcc.trim(); cnt++;}
                            
                            
                            if(AccountName!='' && hr.pr.End_Customer_Account__r.name!=null && hr.pr.End_Customer_Account__r.name!=null) 
                            if(hr.pr.End_Customer_Account__r.name.containsIgnoreCase(AccountName))
                            flag++; 
                            
                             if(ProjectName.trim()!='' && hr.pr.Name!=null ) 
                             if(hr.pr.Name.containsIgnoreCase(ProjectName))
                             flag++;
                    
                    
                            if(ProjectCity!='' && hr.pr.Project_City__c!=null) 
                            if(hr.pr.Project_City__c.containsIgnoreCase(ProjectCity))
                            flag++;
                    
                            if(ProjectState!='' && hr.pr.Project_State__c!=null)
                            if(hr.pr.Project_State__c.containsIgnoreCase(ProjectState))
                            flag++;
                    
                    
                            if(ProjecctZipCode!='' && hr.pr.Project_Zip_Code__c!=null)
                            if(hr.pr.Project_Zip_Code__c.containsIgnoreCase(ProjecctZipCode))
                            flag++;
                    
                            if(ProjectApplicationIndustry!='' && hr.pr.Application__c!=null)
                            if(hr.pr.Application__c.containsIgnoreCase(ProjectApplicationIndustry))
                            flag++;
                    
                            if(project_drp_Stage!='' && hr.pr.Stage__c!=null )
                            if(hr.pr.Stage__c.containsIgnoreCase(project_drp_Stage) && hr.pr.Stage__c.containsOnly(project_drp_Stage))
                            flag++;
                    
                    
                           if(ProjectArchitectAcc!='' && hr.pr.Architect_Account__r.Name!=null)
                           if(hr.pr.Architect_Account__r.Name.containsIgnoreCase( ProjectArchitectAcc) || hr.pr.Architect_Account__r.Name.contains( ProjectArchitectAcc))
                           flag++;
                    
                    
                          if(ProjectInstalledAtAcc!='' && hr.pr.Purchaser_Account__r.Name!=null && hr.pr.Purchaser_Account__r.Name!=null)
                          if(hr.pr.Purchaser_Account__r.Name.containsIgnoreCase(ProjectInstalledAtAcc))
                          flag++;
                     
                     
                          if(ProjectOrderingAcc!='' && hr.pr.Ordering_Account__r.Name!=null && hr.pr.Ordering_Account__r.Name!=null)
                          if(hr.pr.Ordering_Account__r.Name.containsIgnoreCase(ProjectOrderingAcc))
                          flag++;
                    
                    
                         System.debug('Count Value'+cnt);
                        System.debug('Count Value'+flag);
                    
                    if(cnt == flag)
                    
                    {
                    
                    
                            filterList.add(hr);
                    }
                    
                       if(AccountName!='') 
                
                        filterAcc();
                     
                     
          }
                     
                     
                                     WrapperCombineAllData= filterList;
 
    
    }
               
               
               
               public void filterAcc()
               {
        
                       // AccSiteList = noProjectAccounts();
        
                        List<Account> accTmpList = new List<Account>();
        
                        for (Account a : AccSiteList)
        
                        if(AccountName!='' && a.Name!=null) 
                        if(a.Name.containsIgnoreCase(AccountName))
                        accTmpList.add(a);
                        AccSiteList = accTmpList;    
            }
    
   
    public  PageReference ProjectReset()
    
    {
         WrapperCombineAllData.clear();
       
        
         project_drp_Stage = '';    
        ProjectName= '';
        AccountName= '';
        ProjectCity= '';
        ProjectState= '';
        ProjecctZipCode= '';
        ProjectStage= '';
        ProjectApplicationIndustry= '';
        ProjectArchitectAcc= '';
        ProjectInstalledAtAcc= '';
        ProjectOrderingAcc= '';
         WrapperCombineAllData.addall(SearchProj);
     //   SearchProj.addall(WrapperCombineAllData);
       // PageReference pr = ApexPages.currentPage();
         //   pr.setRedirect(true);
            return null;
    } 
  
    
    // Pagination Related to the Account Without Project
    
    public ApexPages.StandardSetController setCon 
    {
        get {
            if(setCon == null) {  
               // Account without project 
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                      [SELECT Account.Name FROM Account WHERE parent.id =:AccId AND Account.Id NOT IN (SELECT project__C.End_Customer_Account__c FROM project__c) order by Account.name asc ]));
                setCon.setPageSize(Paginationsize);  
                noOfRecords = setCon.getResultSize(); 
                return setcon;
                
            }            
            return setCon;
        }
        set;
    }
    
    //Changes the size of pagination account without pagination 
    public PageReference refreshPageSize() 
    {
         setCon.setPageSize(PaginationSize);
         return null;
    }
 
    // Initialize setCon and return a list of record    
     
    public List<account> getAccountsData()
    {
         return (List<Account>) setCon.getRecords();
    }
/*   
    // Account With Project Pagination Function 
    
    public Boolean hasNext 
   
   {  
        get 
        {  
                    if (intNumberofPages <= intPageNumber) 
        
            {  
               return false;  
            }  
      
      else 
            {  
        
                return true;  
            }  
     }  
     set;  
   }
   

   public Boolean hasPrevious 

   {  
        get 
     {  
            if (intPageNumber == 1) 
       {  
            return false;  
       }  
            else 
       {  
            return true;  
       }  
     }  
     set;  
   }  */
   /*
   public void first() 
   {  
      intPageNumber = 1;  
  //    getLstOppRecords();  
   }  
   
   public void last() 
   
   {  
      intPageNumber=intNumberofPages;   
  //    getLstOppRecords();  
   }   
   
   public void previous() 
   
   {  
       if(intPageNumber>1){
      intPageNumber--;  
       }
 //     getLstOppRecords();  
   }  
    
    public void next() 
    {  
   //   intPageNumber++;  
    //  getLstOppRecords();  
    }  
   
   */
  

 // Wrapper class to combine to project with OpportunityContactROle
    public class Projectwrapper 
    {
        
        public project__c pr{get;set;}
        public list<opportunitycontactrole> opp1{get;set;}
        
        public string name;
        public Projectwrapper( project__C GP, list<opportunitycontactrole> opp)
        {
            this.pr = GP;
            this.opp1 =opp;
            
            
        }
        
     
     // Function to sort the wrapper list 
     
        
       
    }
    
   

    
    /***Method that populate the Picklist with project status ****/
public List<SelectOption> getStageDrp()    
    {    
        List<SelectOption> options =  new List<SelectOption>();    
        options.add(new selectOption('None','--- None ---'));    
        Schema.DescribeFieldResult fieldResult = project__c.Stage__c.getDescribe();    
        List<Schema.picklistEntry> ple = fieldResult.getPicklistValues();    
        for(Schema.picklistEntry f:ple)    
        {    
            options.add(new selectOption(f.getLabel(),f.getValue()));                    
        }    
        return Options;    
    }      


}