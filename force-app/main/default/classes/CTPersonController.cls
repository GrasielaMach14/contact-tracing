public with sharing class CTPersonController {
        public static Blob getToken(String phone){
            Blob targetBlob = Blob.valueOf('phone');
            Blob hash = Crypto.generateDigest('MD5', targetBlob);

            return hash;
        }
   }