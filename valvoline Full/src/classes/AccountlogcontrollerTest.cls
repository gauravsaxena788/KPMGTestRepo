@isTest
public class AccountlogcontrollerTest {
    static testmethod void testacclog(){
        
        Accountlogcontroller acclog=new Accountlogcontroller();
        acclog.getdynamiclist();
        //System.assertEquals(acclog.selectedtype, 'THIS_MONTH');
        
        
        PageReference pageref = Page.AccountLog;
        Test.setCurrentPageReference(pageref);
        
        // create an instance of the controller
        Accountlogcontroller acc= new Accountlogcontroller ();
        acc.selectedtype='THIS_MONTH';
        acc.AllTaskList();
        acc.selectedtype='LAST_N_MONTHS_12';
        acc.AllTaskList();
        acc.selectedtype='LAST_N_MONTHS_24';
        acc.AllTaskList();
        
        
        PageReference pageref1 = Page.AccountLog_PDF;
        Test.setCurrentPageReference(pageref1);
        ApexPages.currentPage().getParameters().put('seltype','THIS_MONTH');
       AccountLog_PDF_controller apdf=new AccountLog_PDF_controller();
         ApexPages.currentPage().getParameters().put('seltype','LAST_N_MONTHS_12');
       AccountLog_PDF_controller apdf1=new AccountLog_PDF_controller();
         ApexPages.currentPage().getParameters().put('seltype','LAST_N_MONTHS_24');
       AccountLog_PDF_controller apdf2=new AccountLog_PDF_controller();
        ApexPages.currentPage().getParameters().put('seltype','THIS_WEEK');
       AccountLog_PDF_controller apdf3=new AccountLog_PDF_controller();
     

    }
}