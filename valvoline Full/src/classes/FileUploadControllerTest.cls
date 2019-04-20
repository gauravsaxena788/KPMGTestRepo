@istest
public class FileUploadControllerTest {
    
    static testmethod void testfileupload(){
        Account acc = VA_utilClass.createAccount();
        insert acc;
        
        FileUploadController.saveChunk(acc.Id, 'fileName', 'test', 'image/jpg', '', acc.Id);  
      //  FileUploadController.appendToFile('test', 'fileName');
        
    }
}