public with sharing class CTPersonController {
    public CTPersonController() {
        public void getToken(String phone){
            Blob targetBlob = Blob.valueOf('phone');
            Blob hash = Crypto.generateDigest('MD5', targetBlob);
        }
    }
}