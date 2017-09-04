package controllers;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.JsonNode;
import play.libs.F;
import play.libs.Json;
import play.libs.ws.WSClient;
import play.libs.ws.WSResponse;
import play.mvc.*;

import views.html.*;

import javax.inject.Inject;
import javax.inject.Singleton;

import java.util.*;

public class Application extends Controller {

    private final Force force;

    @Inject
    public Application(Force force) {
        this.force = force;
    }

    private boolean isSetup() {
        return ((force.consumerKey != null) && (force.consumerSecret != null));
    }

    private String oauthCallbackUrl(Http.Request request) {
        return (request.secure() ? "https" : "http") + "://" + request.host();
    }

    public F.Promise<Result> index(String code) {
        if (isSetup()) {
            if (code == null) {
                // start oauth
                final String url = "https://test.salesforce.com/services/oauth2/authorize?response_type=code" +
                        "&client_id=" + force.consumerKey +
                        "&redirect_uri=" + oauthCallbackUrl(request());
                return F.Promise.pure(redirect(url));
            } else {
                return force.getToken(code, oauthCallbackUrl(request())).flatMap(authInfo ->
                        force.getContacts(authInfo).<Result>map(contacts ->
                                ok(index.render(contacts))
                        )
                ).recover(error -> {
                    if (error instanceof Force.AuthException)
                        return redirect(routes.Application.index(null));
                    else
                        return internalServerError(error.getMessage());
                });
            }
        } else {
            return F.Promise.pure(redirect(routes.Application.setup()));
        }
    }

    public Result setup() {
        if (isSetup()) {
            return redirect(routes.Application.index(null));
        } else {
            final String maybeHerokuAppName = request().host().split(".herokuapp.com")[0].replaceAll(request().host(), "");
            return ok(setup.render(maybeHerokuAppName));
        }
    }


    @Singleton
    public static class Force {

        private final WSClient ws;

        private final String consumerKey;
        private final String consumerSecret;

        @Inject
        public Force(play.Application app, WSClient ws) {
            this.ws = ws;
            this.consumerKey = app.configuration().getString("consumer.key");
            this.consumerSecret = app.configuration().getString("consumer.secret");
        }

        public F.Promise<AuthInfo> getToken(String code, String redirectUrl) {
            F.Promise<WSResponse> responsePromise = ws.url("https://test.salesforce.com/services/oauth2/token")
                    .setQueryParameter("grant_type", "authorization_code")
                    .setQueryParameter("code", code)
                    .setQueryParameter("client_id", consumerKey)
                    .setQueryParameter("client_secret", consumerSecret)
                    .setQueryParameter("redirect_uri", redirectUrl)
                    .post("");

            return responsePromise.flatMap(response -> {
                JsonNode jsonNode = response.asJson();
                if (jsonNode.has("error"))
                    return F.Promise.throwing(new AuthException(jsonNode.get("error").textValue()));
                else
                    return F.Promise.pure(Json.fromJson(jsonNode, AuthInfo.class));
            });
        }

        @JsonIgnoreProperties(ignoreUnknown = true)
        public static class Contact {
            public String Id;
            public String Name;
            public String AccountId;
            public AccountClass Account;                     
        }

        @JsonIgnoreProperties(ignoreUnknown = true)
        public static class AccountClass {
            //public String Id;
            public Map<String,String> attributes;
            public String Name;
            public String Phone;
            public String BillingCity;
            public String BillingCountry;
            public String BillingPostalCode;
            public String BillingState;
            public String BillingStreet;            
            public OwnerClass Owner;                       
        }

        @JsonIgnoreProperties(ignoreUnknown = true)
        public static class OwnerClass {
            public Map<String,String> attributes;
            public String Name;
        }

        @JsonIgnoreProperties(ignoreUnknown = true)
        private static class QueryResultAccount {
            public List<Contact> records;
        }

        @JsonIgnoreProperties(ignoreUnknown = true)
        private static class AuthInfo {
            @JsonProperty("access_token")
            public String accessToken;

            @JsonProperty("instance_url")
            public String instanceUrl;
        }

        protected static class AuthException extends Exception {
            public AuthException(String message) {
                super(message);
            }
        }

        public F.Promise<List<Contact>> getContacts(AuthInfo authInfo) {
            F.Promise<WSResponse> responsePromise = ws.url(authInfo.instanceUrl + "/services/data/v34.0/query/")
                    .setHeader("Authorization", "Bearer " + authInfo.accessToken)
                    .setQueryParameter("q", "SELECT Id,Name,accountid,account.name,account.phone,account.owner.name,account.BillingCity,account.BillingCountry,account.BillingPostalCode,account.BillingState,account.BillingStreet FROM Contact where accountid!=null and account.phone!=null order by lastmodifieddate desc")
                    .get();

            return responsePromise.flatMap(response -> {
                JsonNode jsonNode = response.asJson();
                System.out.println(jsonNode);
                /*for(JsonNode root : jsonNode){
                Account acc = new Account();
                acc.Name = root.path("Name").asText();
                System.out.println("Id : " + acc.Name);
                } */
                F.Promise<List<Contact>> tesAcc = F.Promise.pure(Json.fromJson(jsonNode, QueryResultAccount.class).records);
                System.out.println(tesAcc);   
                if (jsonNode.has("error"))
                    return F.Promise.throwing(new Exception(jsonNode.get("error").textValue()));
                else
                    return F.Promise.pure(Json.fromJson(jsonNode, QueryResultAccount.class).records);
            });
        }
    }

}