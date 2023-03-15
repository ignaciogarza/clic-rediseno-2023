package com.iscreammedia.clic.front.util;

import java.io.IOException;
import java.net.URISyntaxException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Random;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.MultipartFile;

import com.microsoft.azure.storage.CloudStorageAccount;
import com.microsoft.azure.storage.OperationContext;
import com.microsoft.azure.storage.StorageException;
import com.microsoft.azure.storage.blob.BlobContainerPublicAccessType;
import com.microsoft.azure.storage.blob.BlobRequestOptions;
import com.microsoft.azure.storage.blob.CloudBlobClient;
import com.microsoft.azure.storage.blob.CloudBlobContainer;
import com.microsoft.azure.storage.blob.CloudBlockBlob;

@Configuration
public class CommonUtil {
	@Value("${azure.blob.storage.connection}")   
	private  String storageConnectionString;
    
	
	//Azure Blob storage 업로드 
	public String azureFileUtil (MultipartFile file, String original) throws StorageException, IOException, URISyntaxException, InvalidKeyException  {
				
		CloudStorageAccount storageAccount;
		CloudBlobClient blobClient = null;
		CloudBlobContainer container=null;		
		
		//연결 문자열을 구문 분석하고 Blob 저장소와 상호 작용할 Blob 클라이언트 만들기
		
			storageAccount = CloudStorageAccount.parse(storageConnectionString);
			blobClient = storageAccount.createCloudBlobClient();
			container = blobClient.getContainerReference("quickstartcontainer");
			
			//공개 액세스가 가능한 컨테이너가 없는 경우 생성합니다.			
			container.createIfNotExists(BlobContainerPublicAccessType.CONTAINER, new BlobRequestOptions(), new OperationContext());	
					 				
			 if(!file.getOriginalFilename().equals("") ) {
				 //Blob 참조 가져오기				 
				 CloudBlockBlob blob = container.getBlockBlobReference(original);

				 //Blob 생성 및 파일 업로드				 
				 blob.getProperties().setContentType(file.getContentType());
	             blob.upload(file.getInputStream(), file.getSize());
			 }		
		
		return "success";
	}
	
	//인증키 난수 발생    
	public String getKey(int size) throws NoSuchAlgorithmException {
        Random random = SecureRandom.getInstanceStrong();
        StringBuilder buffer = new StringBuilder();
        int num = 0;

        while(buffer.length() < size) {
            num = random.nextInt(10);
            buffer.append(num);
        }

        return buffer.toString();
    }

}
