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
                final String url = "https://login.salesforce.com/services/oauth2/authorize?response_type=code" +
                        "&client_id=" + force.consumerKey +
                        "&redirect_uri=" + oauthCallbackUrl(request());
                return F.Promise.pure(redirect(url));
            } else {
                return force.getToken(code, oauthCallbackUrl(request())).flatMap(authInfo ->
                        force.getAccounts(authInfo).<Result>map(accounts ->
                                ok(index.render(accounts))
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
            F.Promise<WSResponse> responsePromise = ws.url("https://login.salesforce.com/services/oauth2/token")
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
        public static class Account {
            public String Id="";
            public String CaseNumber="";
            public String Origin="";
			public String Priority="";			
			public String Reason="";
            public String Status="";	
			public String Subject="";
            public String Branch_Address__c="";
            public String Branch_Code__c="";
            public String Type;
            public String SubType__c;
            public OwnerClass Owner= new OwnerClass();            			
        }

        @JsonIgnoreProperties(ignoreUnknown = true)
        public static class OwnerClass {
            public Map<String,String> attributes;
            public String Name;
        }

        @JsonIgnoreProperties(ignoreUnknown = true)
        private static class QueryResultAccount {
            public List<Account> records;
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

        public F.Promise<List<Account>> getAccounts(AuthInfo authInfo) {
            F.Promise<WSResponse> responsePromise = ws.url(authInfo.instanceUrl + "/services/data/v34.0/query/")
                    .setHeader("Authorization", "Bearer " + authInfo.accessToken)
                    .setQueryParameter("q", "select id, Type,SubType__c,Branch_Address__c, Branch_Code__c, Owner.name, casenumber,Origin,Priority,Reason,Status,Subject from case order by createddate desc")
                    .get();

            return responsePromise.flatMap(response -> {
                JsonNode jsonNode = response.asJson();
                if (jsonNode.has("error"))
                    return F.Promise.throwing(new Exception(jsonNode.get("error").textValue()));
                else
                    return F.Promise.pure(Json.fromJson(jsonNode, QueryResultAccount.class).records);
            });
        }
    }

}