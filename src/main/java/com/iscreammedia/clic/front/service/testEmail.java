package com.iscreammedia.clic.front.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import javax.mail.MessagingException;

import com.azure.identity.ClientSecretCredential;
import com.azure.identity.ClientSecretCredentialBuilder;
import com.microsoft.graph.authentication.TokenCredentialAuthProvider;
import com.microsoft.graph.models.BodyType;
import com.microsoft.graph.models.EmailAddress;
import com.microsoft.graph.models.InternetMessageHeader;
import com.microsoft.graph.models.ItemBody;
import com.microsoft.graph.models.Message;
import com.microsoft.graph.models.Recipient;
import com.microsoft.graph.models.User;
import com.microsoft.graph.models.UserSendMailParameterSet;
import com.microsoft.graph.requests.GraphServiceClient;


public class testEmail {
	
	//azure.client-id==f9336a35-2c0f-4805-a737-c0da0edb21ce
	//azure.secret-keys=0010e18f-e364-4398-ac3b-e08cbaf336d7
	//azure.tenant-id=f1874ef1-89dc-4194-8266-b50dc692f9a8
	
	
	public static void main(String[] args) throws MessagingException, IOException {
		ClientSecretCredential clientSecretCredential = new ClientSecretCredentialBuilder()
	        	.clientId("f9336a35-2c0f-4805-a737-c0da0edb21ce")
			    .clientSecret("0010e18f-e364-4398-ac3b-e08cbaf336d7")
				.tenantId("f1874ef1-89dc-4194-8266-b50dc692f9a8")
				.build();
	        // END: com.azure.identity.credential.clientsecretcredential.construct
	        
	      
        List<String> scopes = new ArrayList<String>(); 
        scopes.add("https://graph.microsoft.com/.default");
        //scopes.add("https://graph.microsoft.com/Mail.Send");        
        //scopes.add("Mail.Send");
		TokenCredentialAuthProvider tokenCredentialAuthProvider = new TokenCredentialAuthProvider(scopes , clientSecretCredential);
			
			
		sendMail2(tokenCredentialAuthProvider);
	}
	
	

	public static String sendMail2(TokenCredentialAuthProvider tokenCredentialAuthProvider) throws  MessagingException, IOException {	
		
		
		GraphServiceClient graphClient = GraphServiceClient.builder().authenticationProvider( tokenCredentialAuthProvider ).buildClient();

		Message message = new Message();
		message.subject = "Meet for lunch?";
		ItemBody body = new ItemBody();
		body.contentType = BodyType.TEXT;
		body.content = "The new cafeteria is open.";
		message.body = body;
		
		LinkedList<Recipient> toRecipientsList = new LinkedList<Recipient>();
		Recipient toRecipients = new Recipient();
		EmailAddress emailAddress = new EmailAddress();
		emailAddress.address = "jmh10243@naver.com";
		toRecipients.emailAddress = emailAddress;
		toRecipientsList.add(toRecipients);
		message.toRecipients = toRecipientsList;
		

		boolean saveToSentItems = false;

		graphClient.me()
			.sendMail(UserSendMailParameterSet
				.newBuilder()
				.withMessage(message)
				.withSaveToSentItems(saveToSentItems)
				.build())
			.buildRequest()
			.post();
				
		return "ok";
	}
	
	
	
	public static String sendMail1(TokenCredentialAuthProvider tokenCredentialAuthProvider) throws  MessagingException, IOException {	
		
	
		GraphServiceClient graphClient = GraphServiceClient.builder().authenticationProvider( tokenCredentialAuthProvider ).buildClient();

		Message  message = new Message();
		message.subject = "9/9/2018: concert";
		
		ItemBody body = new ItemBody();
		body.contentType = BodyType.HTML;
		body.content = "The group represents Nevada.";		
		message.body = body;
		
		LinkedList<Recipient> toRecipientsList = new LinkedList<Recipient>();
		Recipient toRecipients = new Recipient();
		
		EmailAddress emailAddress = new EmailAddress();
		//emailAddress.address = "jmh10243@naver.com";
		emailAddress.address = "AlexW@contoso.OnMicrosoft.com";
		toRecipients.emailAddress = emailAddress;
		toRecipientsList.add(toRecipients);
		message.toRecipients = toRecipientsList;
		
		LinkedList<InternetMessageHeader> internetMessageHeadersList = new LinkedList<InternetMessageHeader>();
		
		InternetMessageHeader internetMessageHeaders = new InternetMessageHeader();
		internetMessageHeaders.name = "x-custom-header-group-name";
		internetMessageHeaders.value = "Nevada";
		internetMessageHeadersList.add(internetMessageHeaders);
		
		InternetMessageHeader internetMessageHeaders1 = new InternetMessageHeader();
		internetMessageHeaders1.name = "x-custom-header-group-id";
		internetMessageHeaders1.value = "NV001";
		internetMessageHeadersList.add(internetMessageHeaders1);
		message.internetMessageHeaders = internetMessageHeadersList;

		graphClient.me()
			.sendMail(UserSendMailParameterSet
				.newBuilder()
				.withMessage(message)
				.withSaveToSentItems(null)
				.build())
			.buildRequest()
			.post();
				
		return "ok";
	}
	
	
	
	
	
	

	public static void clientSecretCredentialCodeSnippets() {
        // BEGIN: com.azure.identity.credential.clientsecretcredential.construct
        ClientSecretCredential clientSecretCredential = new ClientSecretCredentialBuilder()
        	.clientId("f9336a35-2c0f-4805-a737-c0da0edb21ce")
		    .clientSecret("0010e18f-e364-4398-ac3b-e08cbaf336d7")
		    .tenantId("f1874ef1-89dc-4194-8266-b50dc692f9a8")
            .build();
        // END: com.azure.identity.credential.clientsecretcredential.construct
        
      
        List<String> scopes = new ArrayList<String>();
        scopes.add("Mail.Send");       

		TokenCredentialAuthProvider tokenCredentialAuthProvider = new TokenCredentialAuthProvider(scopes , clientSecretCredential);
        
        GraphServiceClient graphClient1 =
      		  GraphServiceClient
      		    .builder()
      		    .authenticationProvider(tokenCredentialAuthProvider)
      		    .buildClient();

      	User me = graphClient1.me().buildRequest().get();        
    }

	
}
